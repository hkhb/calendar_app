require "test_helper"

module Api
  module V1
    class RegularSchedulesControllerTest < ActionDispatch::IntegrationTest
      setup do
        @user = users(:one)
        @current_user = @user
      end

      test "should create regular schedule" do
        assert_difference('RegularSchedule.count') do
          post api_v1_regular_schedules_url, params: {
            regular_schedule: {
              name: "Test Regular Schedule",
              event: "Test Event",
              start_time: "09:00",
              finish_time: "18:00",
              days: 1,
              user_id: @user.id
            }
          }, as: :json
        end

        assert_response :created
        json_response = JSON.parse(response.body)
        assert_equal "Test Regular Schedule", json_response["name"]
      end

      test "should not create regular schedule with invalid params" do
        assert_no_difference('RegularSchedule.count') do
          post api_v1_regular_schedules_url, params: {
            regular_schedule: {
              name: "", # name is required
              event: "Test Event",
              start_time: "09:00",
              finish_time: "18:00",
              days: 0, # ここを修正 (無効な値)
              user_id: @user.id
            }
          }, as: :json
        end

        assert_response :unprocessable_entity
        json_response = JSON.parse(response.body)
        assert_includes json_response["errors"], "Name can't be blank"
        assert_includes json_response["errors"], "Days must be greater than or equal to 1"
      end
    end
  end
end
