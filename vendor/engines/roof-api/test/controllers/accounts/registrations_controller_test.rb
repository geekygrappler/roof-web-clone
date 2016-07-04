require 'test_helper'

class Accounts::RegistrationsControllerTest < ActionController::TestCase
  test "should return 400 unless account.user.type param" do
    assert_no_difference('Account.count') do
      xhr :post, :create, {format: :json, account: {email: ''}}
    end
    assert_response :bad_request
  end
  test "should validate account" do
    assert_no_difference('Account.count') do
      xhr :post, :create, {format: :json, account: {
        email: '',
        user: {type: 'Customer'}
      }}
    end
    assert_response :unprocessable_entity
  end
  test "should validate user" do
    assert_no_difference('Account.count') do
      xhr :post, :create, {format: :json, account: {
        email: 'test@test.com',
        password: 'password',
        user: {type: 'Customer'}
      }}
    end
    assert_response :unprocessable_entity
  end
  test "should create" do
    assert_difference('Account.count') do
      xhr :post, :create, {format: :json, account: {
        email: 'test@test.com',
        password: 'password',
        user: {
          type: 'Customer',
          profile: {
            first_name: 'Hans',
            last_name: 'Ulrich',
            phone_number: '445675656'
          }
        }
      }}
    end
    assert_response :success
  end
end
