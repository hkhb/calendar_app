module Api
  module V1
    class RegularSchedulesController < ApplicationController
      # before_action :authenticate_user

      # GET /api/v1/regular_schedules
      # 現在のユーザーの全ての定期スケジュールを取得します。
      def index
        @regularSchedules = RegularSchedule.where(user_id: @current_user.id)
        render json: @regularSchedules
      end

      # POST /api/v1/regular_schedules
      # 新しい定期スケジュールを作成します。
      # パラメータ:
      #   regular_schedule: { name: "...", event: "...", start_time: "...", finish_time: "...", days: "...", user_id: "..." }
      def create
        Rails.logger.debug "RegularSchedulesController#create: Params received: #{regular_schedule_params.inspect}, user_id: #{regular_schedule_params[:user_id].inspect}" # 追加
        result = RegularSchedule.regularschedule_create(regular_schedule_params, regular_schedule_params[:user_id])
        Rails.logger.debug "RegularSchedulesController#create: Result from model: #{result.inspect}" # 追加

        if result.is_a?(RegularSchedule) && result.persisted?
          Rails.logger.debug "RegularSchedulesController#create: Rendering success (RegularSchedule persisted)." # 追加
          render json: result, status: :created
        elsif result.is_a?(Array) # バリデーションエラーメッセージの配列の場合
          Rails.logger.debug "RegularSchedulesController#create: Rendering validation errors: #{result.inspect}" # 追加
          render json: { errors: result }, status: :unprocessable_entity
        elsif result == "unexpected_error" # モデルから "unexpected_error" が返された場合
          Rails.logger.debug "RegularSchedulesController#create: Rendering unexpected error." # 追加
          render json: { errors: ["An unexpected error occurred during regular schedule creation."] }, status: :internal_server_error
        else # その他のエラーの場合 (nil など)
          Rails.logger.debug "RegularSchedulesController#create: Rendering generic failure." # 追加
          render json: { errors: ["Failed to create regular schedule"] }, status: :unprocessable_entity
        end
      end

      # GET /api/v1/regular_schedules/:id
      # 指定されたIDの定期スケジュールを取得します。
      def show
        @regularschedule = RegularSchedule.find_by(id: params[:id])
        render json: @regularschedule
      end

      # PATCH/PUT /api/v1/regular_schedules/:id
      # 指定されたIDの定期スケジュールを更新します。
      # パラメータ:
      #   regular_schedule: { name: "...", event: "...", start_time: "...", finish_time: "...", days: "...", user_id: "..." }
      def update
        @regular_schedule = RegularSchedule.find(params[:id])
        if result.is_a?(RegularSchedule)
          render json: result
        elsif result.is_a?(Array)
          render json: { errors: result }, status: :unprocessable_entity
        elsif result == "unexpected_error"
          render json: { errors: ["An unexpected error occurred during regular schedule update."] }, status: :internal_server_error
        else
          render json: { errors: ["Failed to update regular schedule"] }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/regular_schedules/:id
      # 指定されたIDの定期スケジュールを削除します。
      def destroy
        schedule = RegularSchedule.find_by(id: params[:id])
        if schedule && schedule.destroy
          head :no_content
        else
          render json: { error: "削除に失敗しました。もう一度やり直してください！" }, status: :unprocessable_entity
        end
      end

      private

      def regular_schedule_params
        params.require(:regular_schedule).permit(:name, :event, :user_id, :start_time, :days, :finish_time)
      end
    end
  end
end