require 'test_helper'

class DocumentStatesControllerTest < ActionController::TestCase
  setup do
    @document_state = document_states(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:document_states)
  end

  test "should create document_state" do
    assert_difference('DocumentState.count') do
      post :create, document_state: { description: @document_state.description, name: @document_state.name }
    end

    assert_response 201
  end

  test "should show document_state" do
    get :show, id: @document_state
    assert_response :success
  end

  test "should update document_state" do
    put :update, id: @document_state, document_state: { description: @document_state.description, name: @document_state.name }
    assert_response 204
  end

  test "should destroy document_state" do
    assert_difference('DocumentState.count', -1) do
      delete :destroy, id: @document_state
    end

    assert_response 204
  end
end
