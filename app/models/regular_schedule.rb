class RegularSchedule < ApplicationRecord
    validates :start_time, :finish_time, :name, :user_id, :days, presence: true
    validates :days, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
    def self.regularschedule_create(params, user)
        return nil unless params && user # nil を返す
        begin
            regularschedule = nil # regularschedule を初期化
            ActiveRecord::Base.transaction do
                # params[:start_time] と params[:finish_time] が文字列の場合、Time オブジェクトに変換
                parsed_start_time = params[:start_time].is_a?(String) ? Time.parse(params[:start_time]) : params[:start_time]
                parsed_finish_time = params[:finish_time].is_a?(String) ? Time.parse(params[:finish_time]) : params[:finish_time]

                regularschedule = RegularSchedule.create!(
                    name: params[:name],
                    event: params[:event],
                    days: params[:days],
                    user_id: user.id,
                    start_time: parsed_start_time, # 修正
                    finish_time: parsed_finish_time # 修正
                )
                regularschedule.update!(days: 1) if regularschedule.days.nil?
            end
            Rails.logger.debug "RegularSchedule created: #{regularschedule.inspect}, persisted: #{regularschedule.persisted?}"
            regularschedule # 成功時に regularschedule オブジェクトを返す
        rescue ActiveRecord::RecordInvalid => e
            Rails.logger.error("定型予定作成失敗: #{params.inspect}, error: #{e.message}")
        Rails.logger.debug "Validation errors: #{e.record.errors.full_messages.inspect}" # この行を追加
        e.record.errors.full_messages # Return array of error messages
        rescue => e
            Rails.logger.error("予期しないエラー: #{params.inspect}, error: #{e.message}")
            "unexpected_error" # Return a string for unexpected errors
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
        return nil unless params && id # nil を返す
        begin
            ActiveRecord::Base.transaction do
                regularschedule = nil # regularschedule を初期化
                regularschedule = RegularSchedule.find_by(id: id)
                # params[:start_time] と params[:finish_time] が文字列の場合、Time オブジェクトに変換
                parsed_start_time = params[:start_time].is_a?(String) ? Time.parse(params[:start_time]) : params[:start_time]
                parsed_finish_time = params[:finish_time].is_a?(String) ? Time.parse(params[:finish_time]) : params[:finish_time]

                regularschedule.update!(
                    name: params[:name],
                    event: params[:event],
                    days: params[:days],
                    start_time: parsed_start_time, # 修正
                    finish_time: parsed_finish_time # 修正
                )
            end
            regularschedule # 成功時に regularschedule オブジェクトを返す
        rescue ActiveRecord::RecordInvalid => e
            Rails.logger.error("定型予定更新失敗: #{params.inspect}, error: #{e.message}")
        Rails.logger.debug "Validation errors: #{e.record.errors.full_messages.inspect}" # この行を追加
        e.record.errors.full_messages # Return array of error messages
        rescue => e
            Rails.logger.error("予期しないエラー: #{params.inspect}, error: #{e.message}")
            "unexpected_error" # Return a string for unexpected errors
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
