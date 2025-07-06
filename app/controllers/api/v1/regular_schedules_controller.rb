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
        result = RegularSchedule.regularschedule_create(regular_schedule_params, @current_user)
        if result.is_a?(RegularSchedule) && result.persisted?
          render json: result, status: :created
        elsif result.is_a?(ActiveRecord::Base) && result.errors.present?
          render json: { errors: result.errors.full_messages }, status: :unprocessable_entity
        else
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
          Rails.logger.debug "Controller received validation errors: #{result.inspect}" # この行を追加
          render json: { errors: result }, status: :unprocessable_entity
        else
          Rails.logger.debug "Controller received unexpected result: #{result.inspect}" # この行を追加
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