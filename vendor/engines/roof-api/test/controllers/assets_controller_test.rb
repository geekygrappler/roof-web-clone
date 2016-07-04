require 'test_helper'

class AssetsControllerTest < ActionController::TestCase
  setup do
    @file = File.open('test/support/file.txt')
    @asset = assets(:one)
  end
  teardown do
    @file.close
  end
  test "should create" do
    post :create, {format: :json, asset: {
      file: @file
    }}
    assert_response :success
  end
  test "should destroy" do
    xhr :delete, :destroy, {format: :json, id: @asset.id}
    assert_response :success
  end
end
