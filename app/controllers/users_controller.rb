class UsersController < ApplicationController

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
      redirect_to("/users/#{@user.id}")
    else
      flash.now[:notice] = "失敗しました"
      render("users/new")
    end
  end

  def destory
    redirect_to ("/users/login_form")
  end

  def login_form
  end

  def login
    @user = User.find_by(email: params[:email])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      flash[:notice] = "ログイン"
      redirect_to("/top")
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
      # redirect_to("/users/#{@user.id}/edit") 
      redirect_to  action: :edit, id: @user.id
      #redirect_to edit_user_path(@user)


    else
      flash[:notice] = "パスワードが違います"
      render :authenticate_form

    end
  end

  def update
    @user = User.find(params[:id])
    @user.update(
      name: params[:name],
      email: params[:email],
      password: params[:password]
    )
    if @user.save
      flash[:notice] = "編集しました"
      redirect_to("/users/#{@user.id}")
    else
      render :edit
    end
  end

  def user_info
    @user = User.find_by(id: params[:id])
  end

end
