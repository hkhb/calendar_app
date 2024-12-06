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
        @regularschedule = RegularSchedule.find_by(id: params[:id])

        if @regularschedule.update(
            params.require(:regular_schedule).permit(:name, :event, :number, :days, :start_time, :finish_time)
            )
            create_regularschedule_times(@regularschedule)

            if @regularschedule.save

                flash[:notice] = "定型予定の登録が完了しました"
                redirect_to regularschedule_path(@regularschedule)

            else

                flash[:notice] = "失敗しました"
                render :edit

            end
        else

            flash[:notice] = "失敗しました"
            render :edit

        end
    end

    def new
        @regularschedule = RegularSchedule.new
    end

    def create
        @regularschedule = RegularSchedule.new(
            params.require(:regular_schedule).permit(:name, :event, :number, :days, :start_time, :finish_time)
        )
        @regularschedule.user_id = @current_user.id
        create_regularschedule_times(@regularschedule)

        if @regularschedule.save

            flash[:notice] = "定型予定の登録が完了しました"
            redirect_to regularschedule_path(@regularschedule)

        else

            flash[:notice] = "失敗しました"
            render :new

        end
    end

    def destroy
        @schedule = RegularSchedule.find_by(id: params[:id])

        if @schedule && @schedule.destroy

            flash[:notice] = "スケジュールが削除されました"
            redirect_to regularschedule_path(@schedule)

        else

            flash[:notice] = "削除に失敗しました"
            redirect_to regularschedule_path(@schedule)

        end
    end

    def create_regularschedule_times(regularschedule)
        regularschedule.start_hour = regularschedule.start_time.strftime("%H").to_i
        regularschedule.start_minute = format("%02d", regularschedule.start_time.strftime("%M").to_i)
        regularschedule.finish_hour = regularschedule.finish_time.strftime("%H").to_i
        regularschedule.finish_minute = format("%02d", regularschedule.finish_time.strftime("%M").to_i)
    end

    private

    def regularschedule_params
        params.require(:regular_schedule).permit(:name, :event, :user_id, :number, :start_time, :days, :finish_time)
    end
end
