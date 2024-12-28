class ShiftsController < ApplicationController
    before_action :authenticate_user

    def index
        Date.beginning_of_week = :sunday
        @date = params[:start_date].present? ? Date.parse(params[:start_date]) : Date.current
        @shift = Shift.where(user_id: current_user.id)
        Rails.logger.debug("@date: #{@date}")
    end

    def new
        Date.beginning_of_week = :sunday
        @month = params[:start_date].present? ? Date.parse(params[:start_date]) : Date.current
        @names = RegularSchedule.where(user_id: @current_user.id)
    end

    def create
        logger.debug "Shifts Params: #{params[:shifts]}"
        date = params[:start_date].present? ? Date.parse(params[:start_date]) : Date.current
        @month = params[:start_date].present? ? Date.parse(params[:start_date]) : Date.current

        if Shift.create_monthly(shift_params, @current_user)
          flash[:notice] = "シフト登録が完了しました"
          redirect_to shifts_path(start_date: date.to_s)
        else
            @error_message = "シフト作成に失敗しました。もう一度一度やり直してください"
          render :new
        end
    end

    def edit
        Date.beginning_of_week = :sunday
        @shift = Shift.where(user_id: current_user.id)
        @date = params[:start_date].present? ? params[:start_date].to_date : Date.current
        @names = RegularSchedule.where(user_id: @current_user.id)
    end

    def update
        date = params[:start_date].to_date
        @shift = Shift.where(user_id: current_user.id)

        if Shift.update_monthly(shift_params, @current_user)
            flash[:notice] = "シフト変更が完了しました"
            redirect_to shifts_path(start_date: date.to_s)
        else
            @error_message = "シフト変更に失敗しました。もう一度一度やり直してください"
            render :edit
        end
    end

    def destroy_month
        date = params[:start_date].to_date

        if Shift.destory_monthly(date, @current_user)
            flash[:notice] = "スケジュールが削除されました"
            redirect_to shifts_path(start_date: date.to_s)
        else
            @error_message = "削除に失敗しました"
            render :index
        end
    end

    private

    def shift_params
        params.require(:shifts).map do |shift|
            shift.permit(:date, :name, :user_id, :id)
        end
    end
end
