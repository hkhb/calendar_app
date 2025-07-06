module Api
  module V1
    class ShiftsController < ApplicationController
      # before_action :authenticate_user

      # GET /api/v1/shifts
      # 現在のユーザーの全てのシフトを取得します。
      # パラメータ:
      #   start_date: 開始日 (例: "2024-07-01")
      def index
        @date = params[:start_date].present? ? Date.parse(params[:start_date]) : Date.current
        @shift = Shift.where(user_id: current_user.id)
        render json: @shift
      end

      # POST /api/v1/shifts
      # 新しいシフトをまとめて作成します。
      # パラメータ:
      #   shifts: [ { name: "...", date: "...", user_id: "..." }, ... ]
      def create
        result = Shift.create_monthly(shift_params, @current_user)
        if result.is_a?(Array)
          render json: result, status: :created
        else
          render json: { errors: ["Failed to create shifts"] }, status: :unprocessable_entity
        end
      end

      # GET /api/v1/shifts/:id
      # 指定されたIDのシフトを取得します。
      def show
        @shift = Shift.find_by(id: params[:id])
        render json: @shift
      end

      # PATCH/PUT /api/v1/shifts
      # シフトをまとめて更新します。
      # パラメータ:
      #   shifts: [ { id: "...", name: "...", date: "...", user_id: "..." }, ... ]
      def update
        # update_monthlyは複数のshiftを更新する想定
        # ここでは個別のshiftを更新する例を示す
        @shift = Shift.find(params[:id])
        if @shift.update(shift_params.first) # 配列の最初の要素で更新
          render json: @shift
        else
          render json: { errors: @shift.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/shifts/destroy_month
      # 指定された月のシフトを全て削除します。
      # パラメータ:
      #   start_date: 月の開始日 (例: "2024-07-01")
      def destroy_month
        date = params[:start_date].present? ? params[:start_date].to_date : Date.current
        result = Shift.destory_monthly(date, @current_user)
        if result
          render json: { message: "シフトの更新が完了しました" } # update_monthly はオブジェクトを返さないため
        else
          render json: { errors: ["Failed to update shifts"] }, status: :unprocessable_entity
        end
      end

      private

      def shift_params
        params.require(:shifts).map do |shift|
          shift.permit(:date, :name, :user_id, :id)
        end
      end
    end
  end
end