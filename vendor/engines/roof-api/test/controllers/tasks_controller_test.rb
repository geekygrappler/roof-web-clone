require 'test_helper'

class TasksControllerTest < ActionController::TestCase
  test "admins can manage" do
    sign_in accounts(:acc_admin)
    assert_difference('Task.count') do
      xhr :post, :create, {format: :json, task: {
        :action => 'test',
        :group => 'test',
        :name => 'test',
        :quantity => 1,
        :unit => 'unitless',
        :price => 1,
        :searchable => true,
      }}
    end
    assert_response :success
  end
  test "others can see (search)" do
    sign_in accounts(:acc_custom)
    xhr :get, :index, {format: :json, query: 'Install'}
    assert assigns(:records).count > 0
    assert_response :success
  end
end
