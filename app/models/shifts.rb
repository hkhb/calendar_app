class Shifts < ApplicationRecord
  validates :user_id, :date, presence: true

  def self.create_montly(shift_params, user)
    return false unless shift_params.present?

    begin
      ActiveRecord.base.transaction do
        shift_params.each do |shift_data|
          regularschedule = RegularSchedule.find_by(number: shift_data[:number])

          if regularschedule
            Shift.create(shift_data.(date: shift_data[:date],
                                  number: shift_data[:number],
                                  user_id: user))
            date = Date.parse(shift_data[:date])
            regularschedule.create_regularschedule_to_schedule(regularschedule.number, date, user)
          else
            Shift.create(shift_data.(date: shift_data[:date],
                                    number: nil,
                                    user_id: user))
          end
        end
      end
      true
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.error("シフト作成失敗: #{e.message}")
      false
    rescue => e
      Rails.logger.error("予期しないエラー: #{e.message}")
      false
    end
  end

  def self.update_montly(shift_params, user)
    return false unless shift_params.present?

      shift_params.each do |shift_data|
        shift = Shift.find_by(id: shift_data[:id])
        regularschedule = RegularSchedule.find_by(number: shift_data[:number])

        if regularschedule && shift
          shift.update(number: shift_data[:number])
        else
          shift.update(number: nil)
          Rails.logger.info("shift.update:シフトは変更なし")
        end

        date = Date.parse(shift_data[:date])
        new_shift = shift_data[:number]
        schedule = Schedule.where(user_id: user)
                            .where(start_time: date.all_day)

        if schedule.present?

          schedule.each do |existing_shift|
            old_shift = existing_shift&.number
            Rails.logger.info("shift.update:シフトは変更なし:シフト変更前: #{existing_shift&.number},変更後: #{shift_data[:number]}")

            if new_shift == old_shift
              Rails.logger.info("shift.update:シフトは変更なし:シフト変更前: #{existing_shift&.number},変更後: #{shift_data[:number]}")
            elsif new_shift == nil && old_shift
              existing_shift.destroy
            elsif new_shift  && old_shift
              RegularSchedule.create_regularschedule_to_schedule(new_shift, date, user)
              existing_shift.destroy
            else
              Rails.logger.info("shift.update:スケジュールです。newnumber=#{new_shift || '未設定'},oldnumber=#{old_shift}")
            end
          end
        else
          if regularschedule
            RegularSchedule.create_regularschedule_to_schedule(new_shift, date, user)
          else
            break
          end
        end
      end
      true
  end

  def self.destory_montly(date, user)
    shifts = Shift.where(user_id: user.id,
                        date: date.beginning_of_month..date.end_of_month)
    schedules = Schedule.where(user_id: user.id,
                               start_date: date.beginning_of_month..date.end_of_month)
    if shifts.present?

      schedules.each do |schedule|
        if schedule.number.present?
          schedule.destroy
        end
      end
      shifts.destroy_all
      true
    else
      false
    end
  end
end
