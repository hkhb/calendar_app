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


    def edit
        @schedule = Schedule.find_by(id: params[:id])
    end

    def update
        @schedule = Schedule.find_by(id: params[:id])
        @schedule.start_time.in_time_zone("Tokyo")

        schedule_params = params.require(:schedule).permit(:name, :event, :start_time, :end_time)

        Rails.logger.debug "Schedule Params: #{schedule_params.inspect}"

        if @schedule.update(schedule_params)

            flash[:notice] = "予定の登録が完了しました"
            redirect_to show_by_date_schedules_path(date: @schedule.start_time.to_date)

        else

            flash[:notice] = "失敗しました"
            render :edit

        end
    end

    def new
        @schedule = Schedule.new
        @date = params[:date]
    end

    def create
        @schedule = Schedule.new(
                    params.require(:schedule).permit(:name, :event, :start_time, :end_time)
                    )
        @schedule.user_id = @current_user.id

        if @schedule.save

            flash[:notice] = "予定の登録が完了しました"
            redirect_to show_by_date_schedules_path(date: @schedule.start_time.to_date)

        else

            flash[:notice] = "失敗しました"
            render :new

        end
    end

    def destroy
        @schedule = Schedule.find_by(id: params[:id])

        if @schedule && @schedule.destroy

            flash[:notice] = "スケジュールが削除されました"
            redirect_to show_by_date_schedules_path(date: @schedule.start_time.to_date)
        else

            flash[:notice] = "削除に失敗しました"
            redirect_to show_by_date_schedules_path(date: @schedule.start_time.to_date)

        end
    end
end
