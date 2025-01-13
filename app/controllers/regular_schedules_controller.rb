class RegularSchedulesController < ApplicationController
    before_action :authenticate_user
    def index
        @regular_schedules = RegularSchedule.where(user_id: @current_user.id)
    end
    def show
        @regularschedule = RegularSchedule.find_by(id: params[:id])
    end
    def new
        @regularschedule = RegularSchedule.new
    end
    def create
        result = RegularSchedule.regularschedule_create(regular_schedule_params, @current_user)
        Rails.logger.error("ステータス確認: #{result.inspect}")
        case result
        when :success
            flash[:notice] = "定型予定の登録が完了しました"
            redirect_to regular_schedules_path
        when :invalid_input
            @error_message = "名前、時間は必須です。"
            @regularschedule = RegularSchedule.new(regular_schedule_params)
            Rails.logger.error("エラーメッセージ確認: #{@error_message.inspect}")
            render :new
        when :unexpected
            @error_message = "システムエラー"
            @regularschedule = RegularSchedule.new(regular_schedule_params)
            Rails.logger.error("エラーメッセージ確認: #{@error_message.inspect}")
            render :new
        end
    end
    def edit
        @regularschedule = RegularSchedule.find_by(id: params[:id])
    end
    def update
        id = params[:id]
        result = RegularSchedule.regularschedule_update(regular_schedule_params, id)
        case result
        when :success
            flash[:notice] = "定型予定の更新が完了しました"
            redirect_to regular_schedules_path
        when :invalid_input
            @error_message = "名前、時間は必須です。もう一度やり直してください！"
            @regularschedule = RegularSchedule.find_by(id: id)
            Rails.logger.error("エラーメッセージ確認: #{@error_message.inspect}")
            render :edit
        when :unexpected
            @error_message = "システムエラー"
            @regularschedule = RegularSchedule.find_by(id: id)
            Rails.logger.error("エラーメッセージ確認: #{@error_message.inspect}")
            render :edit
        end
    end
    def destroy
        schedule = RegularSchedule.find_by(id: params[:id])
        if schedule && schedule.destroy
            flash[:notice] = "スケジュールが削除されました"
            redirect_to regular_schedules_path
        else
            @error_message = "削除に失敗しました。もう一度やり直してください！"
            redirect_to regular_schedules_path
        end
    end
    private
    def regular_schedule_params
        params.require(:regular_schedule).permit(:name, :event, :user_id, :start_time, :days, :finish_time)
    end
end
