module Api
  module V1
    class UsersController < ApplicationController
      # GET /api/v1/users
      # 全てのユーザーを取得します。
      def index
        render json: User.all
      end

      # GET /api/v1/users/:id
      # 指定されたIDのユーザーを取得します。
      def show
        user = User.find(params[:id])
        render json: user
      end

      # POST /api/v1/users
      # 新しいユーザーを作成します。
      # パラメータ:
      #   user: { name: "...", email: "...", password: "..." }
      def create
        user = User.new(user_params)
        if user.save
          render json: user, status: :created
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/users/:id
      # 指定されたIDのユーザーを更新します。
      # パラメータ:
      #   user: { name: "...", email: "...", password: "..." }
      def update
        user = User.find(params[:id])
        if user.update(user_params)
          render json: user
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/users/:id
      # 指定されたIDのユーザーを削除します。
      def destroy
        user = User.find(params[:id])
        user.destroy
        head :no_content
      end

      private

      def user_params
        params.require(:user).permit(:name, :email, :password)
      end
    end
  end
end
