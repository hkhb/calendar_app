class HomeController < ApplicationController

def top
end


def home
    Date.beginning_of_week = :sunday
end
