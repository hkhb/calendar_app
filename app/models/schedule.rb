class Schedule < ApplicationRecord
  validates :user_id, :name, :start_time, :end_time, presence: { message: "＊必須！" }

  def self.schedule_create(params, user)
    return :not_found unless params && user
    begin
      schedule = Schedule.new
      ActiveRecord::Base.transaction do
        schedule = Schedule.create!(
          name: params[:name],
          start_time: params[:start_time],
          end_time: params[:end_time],
          event: params[:event],
          user_id: user.id
        )
      end
      schedule.start_time
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.error("予定作成失敗: #{params.inspect}, Error: #{e.message}")
      :invalid_input
    rescue => e
      Rails.logger.error("予期しないエラー: #{params.inspect}, Error: #{e.message}")
      :unexpected
    end
  end

  def self.schedule_update(params, id)
    schedule = Schedule.find_by(id: id)
    return :not_found unless params && schedule
    begin
      ActiveRecord::Base.transaction do
        schedule.update!(
          name: params[:name],
          start_time: params[:start_time],
          end_time: params[:end_time],
          event: params[:event]
        )
      end
      schedule.start_time
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.error("予定更新失敗: #{params.inspect}, Error: #{e.message}")
      :invalid_input
    rescue => e
      Rails.logger.error("予期しないエラー: #{params.inspect}, Error: #{e.message}")
      :unexpected
    end
  end
end
