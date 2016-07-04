require 'test_helper'

class CustomersControllerTest < ActionController::TestCase
  setup do
    @user = users(:custom)
    sign_in accounts(:acc_custom)
  end
  test "should update" do
    xhr :put, :update, {format: :json, id: @user.id, customer: {
      profile: {
        phone_number: 10
      }
    }}
    assert_equal 10, @user.reload.profile.phone_number
    assert_response :success
  end
  test "should not update" do
    xhr :put, :update, {format: :json, id: users(:custom2).id, administrator: {
      profile: {
        phone_number: 10
      }
    }}
    refute_equal 10, users(:custom2).reload.profile.phone_number
    assert_response :forbidden
  end
end
