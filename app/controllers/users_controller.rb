class UsersController < ApplicationController
  before_action :authenticate_user, only: [ :edit, :authenticate_form, :authenticate, :update, :show ]
  before_action :forbid_login_user, only: [ :new, :create, :login, :login_form ]
  before_action :ensure_correct_user, only: [ :edit, :update, :authenticate_form, :authenticate ]
  def new
    @user = User.new
  end
  def create
    result = User.user_create(user_params)
    if result.is_a?(User)
      session[:user_id] = result.id
      flash[:notice] = "ユーザー登録が完了しました"
      redirect_to user_path(result)
    else
      @user = User.new(user_params)
      case result
      when :not_found
        @error_message = "もう一度やり直してください！"
      when :invalid_input
        @error_message = "名前、メールアドレス、パスワードは必須です！"
      when :unexpected_error
        @error_message = "システムエラー"
      end
      render :new
    end
  end
  def logout
    session[:user_id] = nil
    flash[:notice] = "ログアウト"
    redirect_to ("/")
  end
  def login_form
  end
  def login
    @user = User.find_by(email: params[:email])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      flash[:notice] = "ログイン"
      redirect_to("/home")
    else
      @error_message = "メールアドレスまたはパスワードが違います！"
      @email = params[:email]
      render :login_form
    end
  end
  def authenticate_form
    @user = User.find_by(id: params[:id])
  end
  def authenticate
    @user = User.find_by(id: session[:user_id])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      flash[:notice] = "ログインしました"
      redirect_to edit_user_path(@user)
    else
      @error_message = "パスワードが違います！"
      render :authenticate_form
    end
  end
  def edit
    @user = User.find_by(id: params[:id])
  end
  def update
    @user = User.find_by(id: params[:id])
    result = User.user_update(user_params, @user)
    if result.is_a?(User)
      flash[:notice] = "変更しました"
      redirect_to user_path(result)
    else
      case result
      when :not_found
        @error_message = "もう一度やり直してください！"
      when :invalid_input
        @error_message = "名前、メールアドレス、パスワードは必須です！"
      when :unexpected_error
        @error_message = "システムエラー"
      end
      render :edit
    end
  end
  def show
    @user = User.find_by(id: params[:id])
  end
  def ensure_correct_user
    if @current_user.id != params[:id].to_i
      flash[:notice] = "権限がありません"
      redirect_to("/home")
    end
  end
  private
  def user_params
    params.require(:user).permit(:name, :email, :password)
  end
end
