require 'test_helper'

class Accounts::SessionsControllerTest < ActionController::TestCase

  test "should not signin" do
    xhr :post, :create, {format: :json, account: {
      email: '',
      password: 'password'
    }}
    assert_response :unauthorized
  end

  test "should signin" do
    xhr :post, :create, {format: :json, account: {
      email: accounts(:acc_custom).email,
      password: 'password'
    }}
    assert_response :success
  end

  test "should signout" do
    sign_in accounts(:acc_custom)
    xhr :delete, :destroy, {format: :json}
    assert_response :success
  end
end
