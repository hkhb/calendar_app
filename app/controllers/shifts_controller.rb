class ShiftsController < ApplicationController
    before_action :authenticate_user

    def index
        Date.beginning_of_week = :sunday
        @shift = Shift.where(user_id: current_user.id)
        @date = params[:start_date].present? ? Date.parse(params[:start_date]) : Date.current
    end

    def new
        Date.beginning_of_week = :sunday
        @date = params[:start_date].present? ? Date.parse(params[:start_date]) : Date.current
    end

    def create
        shift_params = params[:shifts]
        input_date = params[:date]

        if shift_params
            shift_params.each do |shift_data|
                regularschedule = RegularSchedule.find_by(number: shift_data[:number])

                if regularschedule

                    Shift.create(shift_data.permit(:date, :number, :user_id))
                    date = Date.parse(shift_data[:date])
                    create_schedule(regularschedule.number, date)

                else

                    Shift.create(shift_data.permit(:date, :user_id)
                                .merge(number: 0))

                end
            end

          flash[:notice] = "シフト登録が完了しました"
          redirect_to shifts_path(start_date: input_date.to_s)

        else

          flash[:alert] = "シフト登録に失敗しました"
          render :new

        end
    end

    def edit
        Date.beginning_of_week = :sunday
        @shift = Shift.where(user_id: current_user.id)
        @date = params[:start_date].present? ? params[:start_date].to_date : Date.current
    end

    def update
        shift_params = params[:shifts]
        date = params[:date].to_d

        if shift_params.present?

            shift_params.each do |shift_data|
                shift = Shift.find_by(id: shift_data[:id])
                regularschedule = RegularSchedule.find_by(number: shift_data[:number])

                if regularschedule && shift

                    shift.update(number: shift_data[:number])

                else

                    shift.update(number: 0)

                end

                date = Date.parse(shift_data[:date])
                new_shift = shift_data[:number]
                schedule = Schedule.where(user_id: current_user.id)
                                    .where(start_time: date.all_day)

                if schedule.present?

                    schedule.each do |existing_shift|
                        old_shift = existing_shift&.number

                        if new_shift == 0

                            no_available_new_shift = new_shift

                        elsif new_shift

                            available_new_shift = new_shift

                        else

                             Rails.logger.info("shift.update:error:シフト変更前: #{existing_shift&.number},変更後: #{shift_data[:number]}")

                        end

                        if available_new_shift == old_shift

                            Rails.logger.info("shift.update:シフトは変更なし:シフト変更前: #{existing_shift&.number},変更後: #{shift_data[:number]}")

                        elsif no_available_new_shift && old_shift

                            existing_shift.destroy

                        elsif new_shift  && old_shift

                            create_schedule(new_shift, date)
                            existing_shift.destroy

                        else

                            Rails.logger.info("shift.update:スケジュールです。newnumber=#{new_shift || '未設定'},oldnumber=#{old_shift}")

                        end
                    end
                else

                    if regularschedule

                        create_schedule(regularschedule.number, date)
                        Rails.logger.info("shift.update:シフトが新規作成されました")

                    else

                        Rails.logger.error("shift.update:新規シフトの生成を失敗しました。newnumber=#{regularschedule}")

                    end
                end
            end

            flash[:notice] = "シフト変更が完了しました"
            redirect_to shifts_path(start_date: date.to_s)

        else

            flash[:alert] = "シフト変更に失敗しました"
            render :edit

        end
    end

    def destroy_month
        date = params[:start_date].to_date
        shifts = Shift.where(user_id: current_user.id,
                            date: date.beginning_of_month..date.end_of_month)
        schedules = Schedule.where(user_id: current_user.id,
                                   start_date: date.beginning_of_month..date.end_of_month)

        if shifts.present?

            schedules.each do |schedule|
                if schedule.number.present?

                    schedule.destroy
                end
            end

            shifts.destroy_all

            flash[:notice] = "スケジュールが削除されました"
            redirect_to shifts_path(start_date: date.to_s)

        else

            flash[:error] = "削除に失敗しました"
            render :index

        end
    end

    def create_schedule(shiftnumber, date)
        regularschedule = RegularSchedule.find_by(number: shiftnumber)

        if regularschedule

            start_hour = regularschedule.start_time.hour
            start_minute = regularschedule.start_time.min
            end_hour = regularschedule.finish_time.hour
            end_minute = regularschedule.finish_time.min

            start_time = date.in_time_zone + start_hour.hours + start_minute.minutes
            end_time = date.in_time_zone + (regularschedule.days - 1).days + end_hour.hours + end_minute.minutes

            Schedule.create!(user_id: current_user.id,
                            name: regularschedule.name,
                            event: regularschedule.event,
                            start_date: date,
                            finish_date: date + (regularschedule.days - 1).days,
                            start_time: start_time,
                            end_time: end_time,
                            number: shiftnumber
                            )
        end
    end
end
