class Schedule < ApplicationRecord
  validates :user_id, :name, :start_time, :end_time, presence: true

  def self.schedule_create(params, user_id) # 引数を user_id に変更
    Rails.logger.debug "schedule_create called with params: #{params.inspect}, user_id: #{user_id.inspect}" # Added
    return nil unless params && user_id # user_id を使用
    begin
      schedule = nil # schedule を初期化
      ActiveRecord::Base.transaction do
        schedule = Schedule.create!(
          name: params[:name],
          start_time: params[:start_time],
          end_time: params[:end_time],
          event: params[:event],
          user_id: user_id # user_id を直接使用
        )
        Rails.logger.debug "Schedule created: #{schedule.inspect}, persisted: #{schedule.persisted?}"
      end
      Rails.logger.debug "schedule_create returning: #{schedule.inspect}" # Added
      schedule # 成功時に schedule オブジェクトを返す
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.error("予定作成失敗: #{params.inspect}, Error: #{e.message}")
      Rails.logger.debug "Validation errors: #{e.record.errors.full_messages.inspect}" # Added
      e.record.errors.full_messages # Return array of error messages
    rescue => e
      Rails.logger.error("予期しないエラー: #{params.inspect}, Error: #{e.message}")
      "unexpected_error" # Return a string for unexpected errors
    end
  end

  def self.schedule_update(params, id)
    schedule = Schedule.find_by(id: id)
    return nil unless params && schedule # nil を返す
    begin
      ActiveRecord::Base.transaction do
        schedule.update!(
          name: params[:name],
          start_time: params[:start_time],
          end_time: params[:end_time],
          event: params[:event]
        )
      end
      schedule # 成功時に schedule オブジェクトを返す
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.error("予定更新失敗: #{params.inspect}, Error: #{e.message}")
      e.record.errors.full_messages # Return array of error messages
    rescue => e
      Rails.logger.error("予期しないエラー: #{params.inspect}, Error: #{e.message}")
      "unexpected_error" # Return a string for unexpected errors
    end
  end
end
