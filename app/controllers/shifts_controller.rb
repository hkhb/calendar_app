class ShiftsController < ApplicationController

    def show
        Date.beginning_of_week = :sunday
    end

    def new
        Date.beginning_of_week = :sunday
    end

    def edit
        Date.beginning_of_week = :sunday
    end

    def update

    end

    def create
        @shift = Shift.new(shift_params)
        if @shift.save
            flash[:notice] = "シフト登録が完了しました"
          redirect_to show_shifts_path
        else
            flash[:error] = "シフト登録が失敗しました"
            render :new
        end
    end

    private

    def shift_params
        params.require(:shift).permit(:date, :number, :user_id)
      end
      

end
