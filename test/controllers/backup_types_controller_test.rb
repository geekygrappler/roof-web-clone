require 'test_helper'

class BackupTypesControllerTest < ActionController::TestCase
  setup do
    @backup_type = backup_types(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:backup_types)
  end

  test "should create backup_type" do
    assert_difference('BackupType.count') do
      post :create, backup_type: { name: @backup_type.name }
    end

    assert_response 201
  end

  test "should show backup_type" do
    get :show, id: @backup_type
    assert_response :success
  end

  test "should update backup_type" do
    put :update, id: @backup_type, backup_type: { name: @backup_type.name }
    assert_response 204
  end

  test "should destroy backup_type" do
    assert_difference('BackupType.count', -1) do
      delete :destroy, id: @backup_type
    end

    assert_response 204
  end
end
