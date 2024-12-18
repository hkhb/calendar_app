class Shifts < ApplicationRecord
  validates :user_id, :date, presence: true

  def self.create_monthly(shift_params, user)
    return false unless shift_params.present?

    ActiveRecord::Base.transaction do
      begin
        shift_params.each do |params|
          attributes = params.to_h
          regularschedule = RegularSchedule.find_by(number: attributes[:number], user_id: user)

          if regularschedule
            Shift.create!(attributes.merge(date: attributes[:date],
                                  number: attributes[:number],
                                  user_id: user.id))
            date = Date.parse(attributes[:date])
            RegularSchedule.create_regularschedule_to_schedule(regularschedule.number, date, user)
          else
            Shift.create!(attributes.merge(date: attributes[:date],
                                    number: nil,
                                    user_id: user.id))
          end
        end
        true
      rescue ActiveRecord::RecordInvalid => e
        Rails.logger.error("シフト作成失敗: #{shift_params.inspect}, error: #{e.message}")
        raise ActiveRecord::Rollback
      rescue => e
        Rails.logger.error("予期しないエラー: #{shift_params.inspect}, error: #{e.message}")
        raise ActiveRecord::Rollback
      end
    end
  end

  def self.update_monthly(shift_params, user)
    return false unless shift_params.present?

    ActiveRecord::Base.transaction do
      begin
        shift_params.each do |shift_data|
          attributes = shift_data.to_h
          shift = Shift.find_by(id: attributes[:id])
          regularschedule = RegularSchedule.find_by(number: attributes[:number])

          if regularschedule && shift
            shift.update!(number: attributes[:number])
          else
            shift.update!(number: nil)
            Rails.logger.info("shift.update:シフトは変更なし")
          end
        
          date = Date.parse(attributes[:date])
          schedule = Schedule.where(user_id: user.id, start_time: date.all_day)
          new_shift = attributes[:number]

          if schedule.present?
            distinction_schedule(schedule, new_shift, date, attributes, user)
          else
            if regularschedule
              unless RegularSchedule.create_regularschedule_to_schedule(new_shift, date, user)
                Rails.logger.error("Schedule 作成失敗: new_shift=#{new_shift}, date=#{date}, user=#{user}")
                raise ActiveRecord::Rollback
              end
            end
          end
        end
        true
      rescue => e
        Rails.logger.error("update_montly error: #{e.message}")
        raise ActiveRecord::Rollback
        return false
      end
    end
  end

  def self.destory_monthly(date, user)
    shifts = Shift.where(user_id: user.id,
                        date: date.beginning_of_month..date.end_of_month)
    schedules = Schedule.where(user_id: user.id,
                               start_date: date.beginning_of_month..date.end_of_month)
    return false unless shifts.present? && schedules.present?

    ActiveRecord::Base.transaction do
      begin
        schedules.each do |schedule|
          if schedule.number.present?
            schedule.destroy
          end
        end
        shifts.destroy_all
        true
      rescue ActiveRecord::RecordInvalid => e
        Rails.logger.error("シフト削除失敗: #{e.message}")
        raise ActiveRecord::Rollback
      rescue  => e
        Rails.logger.error("予期しないエラー: #{e.message}")
        raise ActiveRecord::Rollback
      end
    end
  end

  def self.distinction_schedule(schedule, new_shift, date, shift_data, user)
    schedule.each do |existing_shift|
      old_shift = existing_shift&.number
      Rails.logger.info("shift.update:シフトは変更なし:シフト変更前: #{existing_shift&.number},変更後: #{shift_data[:number]}")

      case
      when new_shift == old_shift
        Rails.logger.info("shift.update:シフトは変更なし:シフト変更前: #{existing_shift&.number},変更後: #{shift_data[:number]}")
      when new_shift.nil? && old_shift
        existing_shift.destroy
      when new_shift  && old_shift
        RegularSchedule.create_regularschedule_to_schedule(new_shift, date, user)
        existing_shift.destroy
      else
        Rails.logger.info("shift.update:スケジュールです。newnumber=#{new_shift || '未設定'},oldnumber=#{old_shift}")
      end
    end
  end
end
