require 'test_helper'

class AppointmentsControllerTest < ActionController::TestCase
  setup do
    @host = users(:custom)
    @attendant = users(:pro2)
    @project = projects(:three)
    sign_in accounts(:acc_custom)
  end
  test "should create" do
    xhr :post, :create, {format: :json, appointment: {
      time: DateTime.now + 1.day,
      host_id: @host.id,
      host_type: @host.type,
      attendant_id: @attendant.id,
      attendant_type: @attendant.type,
      project_id: @project.id
    }}
    assert_response :success
  end
  test "should forbid create" do
    xhr :post, :create, {format: :json, appointment: {
      time: DateTime.now + 1.day,
      host_id: @host.id,
      host_type: @host.type,
      attendant_id: @attendant.id,
      attendant_type: @attendant.type,
      project_id: projects(:two).id
    }}
    assert_response :success
  end
  test "should destroy" do
    xhr :delete, :destroy, {format: :json, id: appointments(:one).id}
    assert_response :success
  end
  test "should forbid destroy" do
    xhr :delete, :destroy, {format: :json, id: appointments(:two).id}
    assert_response :forbidden
  end
end
