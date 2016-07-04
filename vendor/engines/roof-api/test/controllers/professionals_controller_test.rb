require 'test_helper'

class ProfessionalsControllerTest < ActionController::TestCase
  setup do
    @user = users(:pro)
    sign_in accounts(:acc_pro)
  end
  test "should update" do
    xhr :put, :update, {format: :json, id: @user.id, professional: {
      profile: {
        guarantee_duration: 10
      }
    }}
    assert_equal 10, @user.reload.profile.guarantee_duration
    assert_response :success
  end
  test "should not update" do
    xhr :put, :update, {format: :json, id: users(:pro2).id, administrator: {
      profile: {
        phone_number: 10
      }
    }}
    refute_equal 10, users(:pro2).reload.profile.phone_number
    assert_response :forbidden
  end
end
