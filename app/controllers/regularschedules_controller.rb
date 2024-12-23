class RegularschedulesController < ApplicationController
    before_action :authenticate_user

    def index
        @regular_schedules = RegularSchedule.where(user_id: @current_user.id)
    end

    def show
        @regular_schedules = RegularSchedule.where(user_id: @current_user.id)
    end



    def edit
        @regularschedule = RegularSchedule.find_by(id: params[:id])
    end

    def update
        regularschedule = RegularSchedule.find_by(id: params[:id])

        if regularschedule.update(
            params.require(:regular_schedule).permit(:name, :event, :number, :days, :start_time, :finish_time)
            )
            regularschedule.create_regularschedule_times

            if regularschedule.save
                flash[:notice] = "定型予定の登録が完了しました"
                redirect_to regularschedules_path
            else
                @error_message = "失敗しました。もう一度入力してください！"
                render :edit
            end
        else
            @error_message = "失敗しました。もう一度入力してください！"
            render :edit
        end
    end

    def new
        @regularschedule = RegularSchedule.new
    end

    def create
        regularschedule = RegularSchedule.new(
            params.require(:regular_schedule).permit(:name, :event, :number, :days, :start_time, :finish_time)
        )
        if regularschedule.days == nil
          regularschedule.days = 1
        end
        regularschedule.user_id = @current_user.id
        regularschedule.create_regularschedule_times

        if regularschedule.save
            flash[:notice] = "定型予定の登録が完了しました"
            redirect_to regularschedules_path
        else
            @error_message = "失敗しました。もう一度入力してください！"
            render :new
        end
    end

    def destroy
        schedule = RegularSchedule.find_by(id: params[:id])

        if schedule && schedule.destroy
            flash[:notice] = "スケジュールが削除されました"
            redirect_to regularschedules_path
        else
            flash[:notice] = "削除に失敗しました"
            redirect_to regularschedules_path
        end
    end


    private

    def regularschedule_params
        params.require(:regular_schedule).permit(:name, :event, :user_id, :number, :start_time, :days, :finish_time)
    end
end
