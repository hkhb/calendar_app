require "test_helper"

module Api
  module V1
    class SchedulesControllerTest < ActionDispatch::IntegrationTest
      setup do
        @user = users(:one) # fixturesからユーザーを取得
        @current_user = @user # @current_user を設定
        # @auth_headers = { 'Authorization' => "Bearer #{JsonWebToken.encode(user_id: @user.id)}" }
      end

      test "should create schedule" do
        assert_difference('Schedule.count') do
          post api_v1_schedules_url, params: {
            schedule: {
              name: "Test Schedule",
              event: "Test Event",
              start_time: Time.now,
              end_time: Time.now + 1.hour,
              user_id: @user.id
            }
          }, as: :json #, headers: @auth_headers
        end

        assert_response :created
        json_response = JSON.parse(response.body)
        assert_equal "Test Schedule", json_response["name"]
      end

      test "should not create schedule with invalid params" do
        assert_no_difference('Schedule.count') do
          post api_v1_schedules_url, params: {
            schedule: {
              name: "", # name is required
              event: "Test Event",
              start_time: Time.now,
              end_time: Time.now + 1.hour,
              user_id: @user.id
            }
          }, as: :json #, headers: @auth_headers
        end

        assert_response :unprocessable_entity
        json_response = JSON.parse(response.body)
        assert_includes json_response["errors"], "Name can't be blank" # エラーメッセージの検証を追加
      end
    end
  end
end
