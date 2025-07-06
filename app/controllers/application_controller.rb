# frozen_string_literal: true

# APIモードで動作させるため、ActionController::APIを継承する
class ApplicationController < ActionController::API
  # APIモードではブラウザ向けの機能は不要なためコメントアウト
  # allow_browser versions: :modern

  before_action :set_current_user

  include UsersHelper

  def set_current_user
    @current_user = User.find_by(id: session[:user_id])
  end

  # APIモードではセッション管理やリダイレクトは行わないため、関連する処理をコメントアウト
  # トークンベースの認証などに置き換える必要がある
  def authenticate_user
    return unless @current_user.nil? || @current_user == session[:user_id]
    # flash[:notice] = "ログインが必要です"
    # redirect_to("/login")
  end

  def forbid_login_user
    return unless @current_user

    # flash[:notice] = "すでにログインしています"
    # redirect_to("/")
  end
end
