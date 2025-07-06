require "test_helper"

module Api
  module V1
    class ShiftsControllerTest < ActionDispatch::IntegrationTest
      setup do
        @user = users(:one)
        @current_user = @user
      end

      test "should create shifts" do
        shifts_params = [
          { name: "Early Shift", date: Date.today, user_id: @user.id },
          { name: "Late Shift", date: Date.today + 1.day, user_id: @user.id }
        ]

        assert_difference('Shift.count', 2) do
          post api_v1_shifts_url, params: { shifts: shifts_params }, as: :json
        end

        assert_response :created
        json_response = JSON.parse(response.body)
        assert_equal 2, json_response.size
        assert_equal "Early Shift", json_response.first["name"]
      end

      test "should not create shifts with invalid params" do
        shifts_params = [
          { name: "", date: Date.today, user_id: @user.id }, # name is required
          { name: "Late Shift", date: Date.today + 1.day, user_id: @user.id }
        ]

        assert_no_difference('Shift.count') do
          post api_v1_shifts_url, params: { shifts: shifts_params }, as: :json
        end

        assert_response :unprocessable_entity
        json_response = JSON.parse(response.body)
        assert_includes json_response["errors"], "Failed to create shifts" # エラーメッセージの検証を追加
      end
    end
  end
end
