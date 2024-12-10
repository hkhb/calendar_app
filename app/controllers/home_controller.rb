class HomeController < ApplicationController
    before_action :authenticate_user, only: [ :home ]
    before_action :forbid_login_user, { only: [ :top ] }

    def top
    end

    def home
        Date.beginning_of_week = :sunday
    end
end
