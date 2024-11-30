class UsersController < ApplicationController

  before_action :authenticate_user, only: [:edit, :authenticate_form,
  :authenticate, :update, :show]
  before_action :forbid_login_user, only: [:new, :create, :login, :login_form]
  before_action :ensure_correct_user, only:[:edit, :update, :authenticate_form, :authenticate]

  def new
    @user = User.new
  end

  def create
    @user = User.new(
      name: params[:name],
      email: params[:email],
      password: params[:password]
      )
    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = "ユーザー登録が完了しました"
      redirect_to user_path(@user)
    else
      flash.now[:notice] = "失敗しました"
      render("users/new")
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

  def edit
    @user = User.find_by(id: params[:id])
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
      flash[:notice] = "パスワードが違います"
      render :authenticate_form

    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update(params.require(:user).permit(:name, :email, :password))
      flash[:notice] = "編集しました"
      redirect_to user_path(@user)
    else
      flash[:notice] = "失敗しました"
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
end
