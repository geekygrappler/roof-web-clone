require 'test_helper'

class AdministratorsControllerTest < ActionController::TestCase
  setup do
    @user = users(:admin)
    sign_in accounts(:acc_admin)
  end
  test "should update" do
    xhr :put, :update, {format: :json, id: @user.id, administrator: {
      profile: {
        phone_number: 10
      }
    }}
    assert_equal 10, @user.reload.profile.phone_number
    assert_response :success
  end
  test "should update as it's admin" do
    xhr :put, :update, {format: :json, id: users(:admin2).id, administrator: {
      profile: {
        phone_number: 10
      }
    }}
    assert_equal 10, users(:admin2).reload.profile.phone_number
    assert_response :success
  end
end
