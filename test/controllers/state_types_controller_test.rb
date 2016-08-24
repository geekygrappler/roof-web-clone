require 'test_helper'

class StateTypesControllerTest < ActionController::TestCase
  setup do
    @state_type = state_types(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:state_types)
  end

  test "should create state_type" do
    assert_difference('StateType.count') do
      post :create, state_type: { calculation: @state_type.calculation, description: @state_type.description, metric: @state_type.metric, name: @state_type.name }
    end

    assert_response 201
  end

  test "should show state_type" do
    get :show, id: @state_type
    assert_response :success
  end

  test "should update state_type" do
    put :update, id: @state_type, state_type: { calculation: @state_type.calculation, description: @state_type.description, metric: @state_type.metric, name: @state_type.name }
    assert_response 204
  end

  test "should destroy state_type" do
    assert_difference('StateType.count', -1) do
      delete :destroy, id: @state_type
    end

    assert_response 204
  end
end
