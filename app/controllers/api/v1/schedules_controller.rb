module Api
  module V1
    class SchedulesController < ApplicationController
      # before_action :authenticate_user

      # GET /api/v1/schedules
      # 現在のユーザーの全てのスケジュールを取得します。
      def index
        @schedules = Schedule.where(user_id: @current_user.id)
        render json: @schedules
      end

      # GET /api/v1/schedules/show_by_date
      # 指定された日付のスケジュールを取得します。
      # パラメータ:
      #   date: 日付 (例: "2024-07-07")
      def show_by_date
        @date = params[:date].present? ? params[:date].to_date : Date.current
        @date_in_jst = Time.zone.local(@date.year, @date.month, @date.day).beginning_of_day..Time.zone.local(@date.year, @date.month, @date.day).end_of_day
        Rails.logger.debug "Selected Date: #{@date}, JST Range: #{@date_in_jst}"
        @schedules = Schedule.where(user_id: @current_user.id)
                             .where(start_time: @date.beginning_of_day..@date.end_of_day)
        Rails.logger.debug "Schedules: #{@schedules.inspect}"
        render json: @schedules
      end

      # POST /api/v1/schedules
      # 新しいスケジュールを作成します。
      # パラメータ:
      #   schedule: { name: "...", event: "...", start_time: "...", end_time: "..." }
      def create
        result = Schedule.schedule_create(schedule_params, @current_user)
        if result.is_a?(Schedule) && result.persisted?
          render json: result, status: :created
        elsif result.is_a?(Array) # バリデーションエラーメッセージの配列の場合
          render json: { errors: result }, status: :unprocessable_entity
        else # その他のエラーの場合
          render json: { errors: ["Failed to create schedule"] }, status: :unprocessable_entity
        end
      end

      # GET /api/v1/schedules/:id
      # 指定されたIDのスケジュールを取得します。
      def show
        @schedule = Schedule.find_by(id: params[:id])
        render json: @schedule
      end

      # PATCH/PUT /api/v1/schedules/:id
      # 指定されたIDのスケジュールを更新します。
      # パラメータ:
      #   schedule: { name: "...", event: "...", start_time: "...", end_time: "..." }
      def update
        result = Schedule.schedule_update(schedule_params, params[:id])
        if result.is_a?(Schedule)
          render json: result
        elsif result.is_a?(Array)
          render json: { errors: result }, status: :unprocessable_entity
        else
          render json: { errors: ["Failed to update schedule"] }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/schedules/:id
      # 指定されたIDのスケジュールを削除します。
      def destroy
        @schedule = Schedule.find_by(id: params[:id])
        if @schedule && @schedule.destroy
          head :no_content
        else
          render json: { error: "削除に失敗しました。もう一度やり直してください" }, status: :unprocessable_entity
        end
      end

      private

      def schedule_params
        params.require(:schedule).permit(:name, :event, :start_time, :end_time, :user_id)
      end
    end
  end
end