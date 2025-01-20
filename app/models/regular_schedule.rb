class RegularSchedule < ApplicationRecord
    validates :start_time, :finish_time, :name, :user_id, presence: true
    def self.regularschedule_create(params, user)
        return :unexpected_error unless params && user
        begin
            ActiveRecord::Base.transaction do
                start_time = Time.new(
                    params["start_time(1i)"].to_i,
                    params["start_time(2i)"].to_i,
                    params["start_time(3i)"].to_i,
                    params["start_time(4i)"].to_i,
                    params["start_time(5i)"].to_i
                )
                finish_time = Time.new(
                    params["finish_time(1i)"].to_i,
                    params["finish_time(2i)"].to_i,
                    params["finish_time(3i)"].to_i,
                    params["finish_time(4i)"].to_i,
                    params["finish_time(5i)"].to_i
                )
                regularschedule = RegularSchedule.create!(
                    params.merge(
                        name: params[:name],
                        event: params[:event],
                        days: params[:days],
                        user_id: user.id,
                        start_time: start_time,
                        finish_time: finish_time
                    )
                )
                regularschedule.update!(days: 1) if regularschedule.days.nil?
            end
            :success
        rescue ActiveRecord::RecordInvalid => e
            Rails.logger.error("定型予定作成失敗: #{params.inspect}, error: #{e.message}")
            :invalid_input
        rescue => e
            Rails.logger.error("予期しないエラー: #{params.inspect}, error: #{e.message}")
            :unexpected_error
        end
    end
    ##
    # regularschedule_update
    # 定型予定を作り出す
    # params: 定型予定の名前
    # id: 入力された日付
    #
    # 引数は全て渡さないと:not_foundを返します。
    # 成功するとtrueを返します。
    def self.regularschedule_update(params, id)
        return :not_found unless params && id
        start_time = Time.new(
            params["start_time(1i)"].to_i,
            params["start_time(2i)"].to_i,
            params["start_time(3i)"].to_i,
            params["start_time(4i)"].to_i,
            params["start_time(5i)"].to_i
          )
          finish_time = Time.new(
            params["finish_time(1i)"].to_i,
            params["finish_time(2i)"].to_i,
            params["finish_time(3i)"].to_i,
            params["finish_time(4i)"].to_i,
            params["finish_time(5i)"].to_i
          )
        begin
            ActiveRecord::Base.transaction do
                regularschedule = RegularSchedule.find_by(id: id)
                regularschedule.update!(
                    name: params[:name],
                    event: params[:event],
                    days: params[:days],
                    start_time: start_time,
                    finish_time: finish_time
                )
            end
            :success
        rescue ActiveRecord::RecordInvalid => e
            Rails.logger.error("定型予定更新失敗: #{params.inspect}, error: #{e.message}")
            :invalid_input
        rescue => e
            Rails.logger.error("予期しないエラー: #{params.inspect}, error: #{e.message}")
            :unexpected_error
        end
    end
    ##
    # create_regularschedule_to_schedule
    # 定型予定から予定を作り出す
    # name: 定型予定の名前
    # date: 入力された日付
    # current_user: 現在ログインしているユーザー名
    # 引数は全て渡さないとfalseを返します。
    # 成功するとtrueを返します。
    def self.create_regularschedule_to_schedule(name, date, current_user)
        regularschedule = RegularSchedule.find_by(name: name)
        return false unless regularschedule && date && current_user
        begin
            start_hour = regularschedule.start_time.hour
            start_minute = regularschedule.start_time.min
            end_hour = regularschedule.finish_time.hour
            end_minute = regularschedule.finish_time.min

            start_time = date.in_time_zone + start_hour.hours + start_minute.minutes
            end_time = date.in_time_zone + (regularschedule.days - 1).days + end_hour.hours + end_minute.minutes

            Schedule.create!(user_id: current_user.id,
                            name: regularschedule.name,
                            event: regularschedule.event,
                            start_date: date,
                            finish_date: date + (regularschedule.days - 1).days,
                            start_time: start_time,
                            end_time: end_time,
                            regular_schedule: true
                            )
            true
        rescue => e
            Rails.logger.error("create_regularschedule_to_schedule error: #{e.message}")
            raise ActiveRecord::Rollback
        end
    end
end
