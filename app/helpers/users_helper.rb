module UsersHelper

    def log_in(user)
        session[:user_id] = user.id
    end
    def current_user
      if session[:user_id]
        @current_user = User.find_by(id: session[:user_id])
      end
    end
    def current_user?(user)
      user == current_user
    end
    def log_out
      session.delete(:user_id)
      @current_user = nil
    end
end
