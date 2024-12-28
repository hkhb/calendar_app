class SchedulesController < ApplicationController
    before_action :authenticate_user

    def index
        @schedules = Schedule.where(user_id: @current_user.id)
    end
    def show_by_date
        @date = params[:date].present? ? params[:date].to_date : Date.current
        @date_in_jst = Time.zone.local(@date.year, @date.month, @date.day).beginning_of_day..Time.zone.local(@date.year, @date.month, @date.day).end_of_day
        Rails.logger.debug "Selected Date: #{@date}, JST Range: #{@date_in_jst}"
        @schedules = Schedule.where(user_id: @current_user.id)
                             .where(start_time: @date.beginning_of_day..@date.end_of_day)
        Rails.logger.debug "Schedules: #{@schedules.inspect}"
        render :show_by_date
    end
    def new
        @schedule = Schedule.new
        @date = params[:date].present? ? params[:date].to_date : Date.current
    end
    def create
        result = Schedule.schedule_create(schedule_params, @current_user)
        if result.is_a?(Time)
            flash[:notice] = "予定の登録が完了しました"
            redirect_to show_by_date_schedules_path(date: result)
        else
            case result
            when :not_found
                @error_message = "データが不正です"
            when :invalid_input
                @error_message = "名前は必須です"
            when :unexpected
                @error_message = "システムエラー"
            end
            @schedule = Schedule.new(schedule_params)
            render :new
        end
    end
    def edit
        @schedule = Schedule.find_by(id: params[:id])
    end
    def update
        id = params[:id]
        result = Schedule.schedule_update(schedule_params, id)
        if result.is_a?(Time)
            flash[:notice] = "予定の更新が完了しました"
            redirect_to show_by_date_schedules_path(date: result)
        else
            case result
            when :not_found
                @error_message = "データが不正です"
            when :invalid_input
                @error_message = "名前は必須です"
            when :unexpected
                @error_message = "システムエラー"
            end
            @schedule = Schedule.find_by!(id: id)
            render :new
        end
    end
    def destroy
        @schedule = Schedule.find_by(id: params[:id])
        if @schedule && @schedule.destroy
            flash[:notice] = "スケジュールが削除されました"
            redirect_to show_by_date_schedules_path(date: @schedule.start_time.to_date)
        else
            @error_message = "削除に失敗しました。もう一度やり直してください"
            redirect_to show_by_date_schedules_path(date: @schedule.start_time.to_date)
        end
    end
    def schedule_params
        params.require(:schedule).permit(:name, :event, :start_time, :end_time)
    end
end
