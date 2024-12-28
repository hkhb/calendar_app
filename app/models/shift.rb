class Shift < ApplicationRecord
  validates :user_id, :date, :name, presence: true

  def self.create_monthly(shift_params, user)
    return false unless shift_params.present?

    begin
      ActiveRecord::Base.transaction do
        shift_params.each do |params|
          attributes = params.to_h
          regularschedule = RegularSchedule.find_by(name: attributes[:name], user_id: user)

          if regularschedule
            Shift.create!(
              attributes.merge(
                date: attributes[:date],
                name: attributes[:name],
                user_id: user.id
                )
              )
            date = Date.parse(attributes[:date])
            RegularSchedule.create_regularschedule_to_schedule(regularschedule.name, date, user)
          else
            Shift.create!(
              attributes.merge(
                date: attributes[:date],
                name: nil,
                user_id: user.id
                )
              )
          end
        end
        true
      end
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.error("シフト作成失敗: #{shift_params.inspect}, error: #{e.message}")
    rescue => e
      Rails.logger.error("予期しないエラー: #{shift_params.inspect}, error: #{e.message}")
    end
  end

  def self.update_monthly(shift_params, user)
    return false unless shift_params.present?

    begin
      ActiveRecord::Base.transaction do
        shift_params.each do |shift_data|
          attributes = shift_data.to_h
          shift = Shift.find_by(id: attributes[:id])
          regularschedule = RegularSchedule.find_by(name: attributes[:name])

          if regularschedule && shift
            shift.update!(name: attributes[:name])
          else
            shift.update!(name: nil)
            Rails.logger.info("shift.update:シフトは変更なし")
          end

          date = Date.parse(attributes[:date])
          schedule = Schedule.where(user_id: user.id, start_time: date.all_day)
          new_shift = attributes[:name]

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
      end
      true
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.error("シフト更新失敗: #{shift_params.inspect}, error: #{e.message}")
    rescue => e
      Rails.logger.error("予期しないエラー: #{shift_params.inspect}, error: #{e.message}")
    end
  end

  def self.destory_monthly(date, user)
    shifts = Shift.where(user_id: user.id,
                        date: date.beginning_of_month..date.end_of_month)
    schedules = Schedule.where(user_id: user.id,
                               start_date: date.beginning_of_month..date.end_of_month)
    return false unless shifts.present? && schedules.present?

    begin
      ActiveRecord::Base.transaction do
        schedules.each do |schedule|
          if schedule.name.present?
            schedule.destroy
          end
        end
        shifts.destroy_all
        true
      end
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.error("シフト削除失敗: #{e.message}")
    rescue  => e
      Rails.logger.error("予期しないエラー: #{e.message}")
    end
  end

  def self.distinction_schedule(schedule, new_shift, date, shift_data, user)
    schedule.each do |existing_shift|
      old_shift = existing_shift&.name
      case
      when new_shift == old_shift
      when new_shift.nil? && old_shift
        existing_shift.destroy
      when new_shift  && old_shift
        RegularSchedule.create_regularschedule_to_schedule(new_shift, date, user)
        existing_shift.destroy
      else
      end
    end
  end
end
