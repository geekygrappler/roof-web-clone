require 'test_helper'

class ProjectsControllerTest < ActionController::TestCase
  setup do
    @account = accounts(:acc_custom)
    @project = projects(:one)
    sign_in @account
  end
  test "should validate" do
    xhr :post, :create, {format: :json, project: {
      name: 'Test',
    }}
    assert_response :unprocessable_entity
  end
  test "should create" do
    assert_difference('Project.count') do
      xhr :post, :create, {format: :json, project: {
        kind: Project.kinds.first,
        brief: {description: 'Yolo!'}
      }}
    end
    assert_response :created
  end
  test "should update" do
    xhr :put, :update, {format: :json, id: @project.id, project: {
      name: 'Doit',
      brief: {preferred_start: 'ASAP'}
    }}
    assert_equal 'ASAP', @project.reload.brief.preferred_start
    assert_response :success
  end
  test "should destroy" do
    assert_difference('Project.count', -1) do
      xhr :delete, :destroy, {format: :json, id: @project.id}
    end
    assert_response :success
  end
  test "should should authorize" do
    assert_no_difference('Project.count', -1) do
      xhr :delete, :destroy, {format: :json, id: projects(:two).id}
    end
    assert_response :forbidden
  end
  test "should authorize" do
    assert_difference('Project.count', -1) do
      xhr :delete, :destroy, {format: :json, id: projects(:three).id}
    end
    assert_response :success
  end

  
  test "should read by professionals pro" do
    sign_out :account
    sign_in accounts(:acc_pro2)
    xhr :get, :show, {format: :json, id: @project.id}
    assert_response :success
  end
  test "should updated by professionals pro" do
    sign_out :account
    sign_in accounts(:acc_pro2)
    xhr :put, :update, {format: :json, id: @project.id, project: {
      name: 'Doit',
      brief: {preferred_start: 'ASAP'}
    }}
    assert_response :success
  end
  test "should not read by others" do
    sign_out :account
    sign_in accounts(:acc_pro3)
    xhr :get, :show, {format: :json, id: @project.id}
    assert_response :forbidden
  end
end
