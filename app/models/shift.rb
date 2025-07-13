class Shift < ApplicationRecord
  validates :user_id, :date, :name, presence: true

  def self.create_monthly(shift_params, user_id) # 引数を user_id に変更
    Rails.logger.debug "create_monthly called with shift_params: #{shift_params.inspect}, user_id: #{user_id.inspect}" # Added
    return nil unless shift_params.present? # nil を返す

    begin
      created_shifts = [] # 作成されたシフトを格納する配列
      ActiveRecord::Base.transaction do
        shift_params.each do |params|
          attributes = params.to_h
          regularschedule = RegularSchedule.find_by(name: attributes[:name], user_id: user_id) # user_id を使用

          shift = Shift.create!( # name: nil を削除し、attributes[:name] を直接使用
            attributes.merge(
              date: attributes[:date],
              name: attributes[:name], # 修正
                user_id: user_id, # user_id を直接使用 # user_id を直接使用
              )
            )
          Rails.logger.debug "Shift created: #{shift.inspect}, persisted: #{shift.persisted?}"

          if regularschedule # regularschedule が存在する場合のみ呼び出す
            date = Date.parse(attributes[:date])
            RegularSchedule.create_regularschedule_to_schedule(regularschedule.name, date, user_id) # user_id を使用
          end
          created_shifts << shift # 作成されたシフトを追加
        end
      end
      created_shifts # 成功時に作成されたシフトの配列を返す
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.error("シフト作成失敗 (validation): #{shift_params.inspect}, error: #{e.message}")
      Rails.logger.debug "Validation errors: #{e.record.errors.full_messages.inspect}"
      nil # Always return nil for any error in create_monthly
    rescue => e
      Rails.logger.error("予期しないエラー: #{shift_params.inspect}, error: #{e.message}")
      Rails.logger.error(e.backtrace.join("\n"))
      nil # Always return nil for any error in create_monthly
    end
  end

  def self.update_monthly(shift_params, user_id) # 引数を user_id に変更
    return nil unless shift_params.present? # nil を返す

    begin
      ActiveRecord::Base.transaction do
        shift_params.each do |shift_data|
          attributes = shift_data.to_h
          shift = Shift.find_by(id: attributes[:id])
          regularschedule = RegularSchedule.find_by(
            user_id: user_id, # user_id を使用
            name: attributes[:name]
            )

          if regularschedule && shift
            shift.update!(name: attributes[:name])
          elsif shift # regularschedule が存在しない場合でも name を更新
            shift.update!(name: attributes[:name]) # 修正
            Rails.logger.info("shift.update:シフトは変更なし")
          end

          date = Date.parse(attributes[:date])
          schedule = Schedule.where(
            user_id: user_id, # user_id を使用
            start_time: date.all_day,
            regular_schedule: true)
          new_shift = attributes[:name]

          if schedule.present?
            distinction_schedule(schedule, new_shift, date, attributes, user_id) # user_id を使用
          else
            if regularschedule # regularschedule が存在する場合のみ呼び出す
              unless RegularSchedule.create_regularschedule_to_schedule(new_shift, date, user_id) # user_id を使用
                Rails.logger.error("Schedule 作成失敗: new_shift=#{new_shift}, date=#{date}, user=#{user_id}")
                raise ActiveRecord::Rollback
              end
            end
          end
        end
      end
      true
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.error("シフト更新失敗: #{shift_params.inspect}, error: #{e.message}")
      e.record.errors.full_messages
    rescue => e
      Rails.logger.error("予期しないエラー: #{shift_params.inspect}, error: #{e.message}")
      "unexpected_error"
    end
  end

  def self.destory_monthly(date, user_id) # 引数を user_id に変更
    shifts = Shift.where(user_id: user_id, # user_id を使用
                        date: date.beginning_of_month..date.end_of_month)
    return nil unless shifts.present? && user_id.present? # user_id を使用

    begin
      ActiveRecord::Base.transaction do
        schedules = Schedule.where(
          user_id: user_id, # user_id を使用
          start_date: date.beginning_of_month..date.end_of_month,
          regular_schedule: true
          )
        if schedules
          schedules.each do |schedule|
            if schedule.name.present?
              schedule.destroy
            end
          end
        end
        shifts.destroy_all
        end
      true # 成功時に true を返す
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.error("シフト削除失敗: #{e.message}")
      e.record.errors.full_messages # Return array of error messages
    rescue  => e
      Rails.logger.error("予期しないエラー: #{e.message}")
      "unexpected_error" # Return a string for unexpected errors
    end
  end

  def self.distinction_schedule(schedule, new_shift, date, shift_data, user_id) # 引数を user_id に変更
    schedule.each do |existing_shift|
      old_shift = existing_shift&.name
      case
      when new_shift == old_shift
      when new_shift.nil? && old_shift
        existing_shift.destroy
      when new_shift  && old_shift
        # regularschedule が存在する場合のみ呼び出す
        regularschedule = RegularSchedule.find_by(name: new_shift, user_id: user_id) # user_id を使用
        if regularschedule
          RegularSchedule.create_regularschedule_to_schedule(new_shift, date, user_id) # user_id を使用
        end
        existing_shift.destroy
      else
      end
    end
  end
end
