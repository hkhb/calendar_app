class RegularschedulesController < ApplicationController
    before_action :authenticate_user

    def index
        @regular_schedules = RegularSchedule.where(user_id: @current_user.id)
    end
    def new
        @regularschedule = RegularSchedule.new
    end
    def create
        if RegularSchedule.regularschedule_create(regularschedule_params, @current_user)
            flash[:notice] = "定型予定の登録が完了しました"
            redirect_to regularschedules_path
        else
            @error_message = "削除に失敗しました。もう一度やり直してください！"
            render :new
        end
    end

    def edit
        @regularschedule = RegularSchedule.find_by(id: params[:id])
    end
    def update
        id = params[:id]
        if RegularSchedule.regularschedule_update(regularschedule_params, id)
            flash[:notice] = "定型予定の登録が完了しました"
            redirect_to regularschedules_path
        else
            @error_message = "削除に失敗しました。もう一度やり直してください！"
            render :edit
        end
    end

    def destroy
        schedule = RegularSchedule.find_by(id: params[:id])

        if schedule && schedule.destroy
            flash[:notice] = "スケジュールが削除されました"
            redirect_to regularschedule_path(schedule)
        else
            @error_message = "削除に失敗しました。もう一度やり直してください！"
            redirect_to regularschedule_path(schedule)
        end
    end


    private

    def regularschedule_params
        params.permit(:name, :event, :user_id, :number, :start_time, :days, :finish_time)
    end
end
