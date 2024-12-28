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
        @date = params[:start_date].present? ? Date.parse(params[:start_date]) : Date.current
        @month = params[:start_date].present? ? Date.parse(params[:start_date]) : Date.current

        result = Shift.create_monthly(shift_params, @current_user)
        case result
        when :success
            flash[:notice] = "シフトの更新が完了しました"
            redirect_to shifts_path(start_date: @date.to_s)
        when :invalid_input
            @error_message = "処理が失敗しました。もう一度やり直してください！"
            render :new
        when :unexpected
            @error_message = "システムエラー"
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
        @date = params[:start_date].present? ? params[:start_date].to_date : Date.current
        @shift = Shift.where(user_id: current_user.id)

        result =  Shift.update_monthly(shift_params, @current_user)
        case result
        when :success
            flash[:notice] = "シフトの作成が完了しました"
            redirect_to shifts_path(start_date: @date.to_s)
        when :invalid_input
            @error_message = "処理が失敗しました。もう一度やり直してください！"
            @names = RegularSchedule.where(user_id: @current_user.id)
            render :edit
        when :unexpected
            @error_message = "システムエラー"
            @names = RegularSchedule.where(user_id: @current_user.id)
            render :edit
        end
    end

    def destroy_month
        @date = params[:start_date].present? ? params[:start_date].to_date : Date.current

        result = Shift.destory_monthly(@date, @current_user)
        case result
        when :success
            flash[:notice] = "スケジュールが削除されました"
            redirect_to shifts_path(start_date: @date.to_s)
        when :invalid_input
            @error_message = "処理が失敗しました。もう一度やり直してください！"
            render :edit
        when :unexpected
            @error_message = "システムエラー"
            render :edit
        end
    end

    private

    def shift_params
        params.require(:shifts).map do |shift|
            shift.permit(:date, :name, :user_id, :id)
        end
    end
end
