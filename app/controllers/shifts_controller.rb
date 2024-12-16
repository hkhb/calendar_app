class ShiftsController < ApplicationController
    before_action :authenticate_user

    def index
        Date.beginning_of_week = :sunday
        @shift = Shift.where(user_id: current_user.id)
        @date = params[:start_date].present? ? Date.parse(params[:start_date]) : Date.current
    end

    def new
        Date.beginning_of_week = :sunday
        @date = params[:start_date].present? ? Date.parse(params[:start_date]) : Date.current
    end

    def create
        shift_params = params[:shifts]
        date = params[:date]

        if Shifts.create_montly(shift_params, @current_user)
          flash[:notice] = "シフト登録が完了しました"
          redirect_to shifts_path(start_date: date.to_s)
        else
          flash[:alert] = "シフト登録に失敗しました"
          render :new
        end
    end

    def edit
        Date.beginning_of_week = :sunday
        @shift = Shift.where(user_id: current_user.id)
        @date = params[:start_date].present? ? params[:start_date].to_date : Date.current
    end

    def update
        shift_params = params[:shifts]
        date = params[:date]

        if Shifts.update_montly(shift_params, @current_user)
            flash[:notice] = "シフト変更が完了しました"
            redirect_to shifts_path(start_date: date)
        else
            flash[:alert] = "シフト変更に失敗しました"
            render :edit
        end
    end

    def destroy_month
        date = params[:start_date].to_date
        shifts.monthly_destory(date)

        if Shifts.destory_montly
            flash[:notice] = "スケジュールが削除されました"
            redirect_to shifts_path(start_date: date.to_s)
        else
            flash[:error] = "削除に失敗しました"
            render :index
        end
    end
end
