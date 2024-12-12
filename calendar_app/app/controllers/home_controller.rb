class HomeController < ApplicationController

    before_action :authenticate_user, only: [:home, :r_schedule_form, :r_schedule] 
    before_action :forbid_login_user, {only: [:top]}
    
    def top
    end

    def home
        Date.beginning_of_week = :sunday
    end

    def r_schedule_form
        @user = User.find_by(id: params[:id])
    end

    def r_schedule
        @user = User.find_by(id: params[:id])
    end

end