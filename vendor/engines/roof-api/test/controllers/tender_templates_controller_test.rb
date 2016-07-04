require 'test_helper'

class TenderTemplatesControllerTest < ActionController::TestCase
  test "should forbid non admins" do
    sign_in accounts(:acc_pro)
    xhr :post, :create, {format: :json, tender_template: {
      document: {
        sections: []
      }
    }}
    assert_response :forbidden
  end
  test "should create" do
    sign_in accounts(:acc_admin)
    assert_difference('TenderTemplate.count') do
      xhr :post, :create, {format: :json, tender_template: {
        name: 'test',
        document: tender_templates(:one).data['document_attributes']
      }}
    end
    assert_response :success
  end
end
