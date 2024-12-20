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
        Rails.logger.debug("@month: #{@month}")
    end

    def create
        logger.debug "Shifts Params: #{params[:shifts]}"
        date = params[:start_date].present? ? Date.parse(params[:start_date]) : Date.current
        @month = params[:start_date].present? ? Date.parse(params[:start_date]) : Date.current

        if Shifts.create_monthly(shifts_params, @current_user)
          flash[:notice] = "シフト登録が完了しました"
          redirect_to shifts_path(start_date: date.to_s)
        else
          flash.now[:alert] = "シフト登録に失敗しました"
          render :new
        end
    end

    def edit
        Date.beginning_of_week = :sunday
        @shift = Shift.where(user_id: current_user.id)
        @date = params[:start_date].present? ? params[:start_date].to_date : Date.current
    end

    def update
        date = params[:start_date].to_date
        @shift = Shift.where(user_id: current_user.id)

        if Shifts.update_monthly(shifts_params, @current_user)
            flash[:notice] = "シフト変更が完了しました"
            redirect_to shifts_path(start_date: date.to_s)
        else
            flash[:alert] = "シフト変更に失敗しました"
            render :edit
        end
    end

    def destroy_month
        date = params[:start_date].to_date

        if Shifts.destory_monthly(date, @current_user)
            flash[:notice] = "スケジュールが削除されました"
            redirect_to shifts_path(start_date: date.to_s)
        else
            flash[:error] = "削除に失敗しました"
            render :index
        end
    end

    private

    def shifts_params
        params.require(:shifts).map do |shift|
            shift.permit(:date, :number, :user_id, :id)
        end
    end
end
