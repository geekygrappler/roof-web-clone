require 'test_helper'

class TendersControllerTest < ActionController::TestCase
  test "admin assigns tender from template to project" do
    sign_in accounts(:acc_admin)
    assert_difference('Tender.count') do
      xhr :post, :create, {format: :json, tender: {
        tender_template_id: tender_templates(:one).id,
        project_id: projects(:one).id
      }}
    end
    assert_response :success
  end
  test "others cannot assigns tender from template to project" do
    sign_in accounts(:acc_pro)
    assert_no_difference('Tender.count') do
      xhr :post, :create, {format: :json, tender: {
        tender_template_id: tender_templates(:one).id,
        project_id: projects(:one).id
      }}
    end
    assert_response :forbidden
  end
  test "customer can create from scratch" do
    sign_in accounts(:acc_custom)
    assert_difference('Tender.count') do
      xhr :post, :create, {format: :json, tender: {
        project_id: projects(:one).id,
        document: tender_templates(:one).data['document_attributes']
      }}
    end
    assert_response :success
  end
  test "pro cannot create from scratch" do
    sign_in accounts(:acc_pro)
    assert_no_difference('Tender.count') do
      xhr :post, :create, {format: :json, tender: {
        project_id: projects(:one).id,
        document: tender_templates(:one).data['document_attributes']
      }}
    end
    assert_response :forbidden
  end
  test "pro can see tender(s)" do
    sign_in accounts(:acc_pro)
    xhr :get, :show, {format: :json, id: tenders(:one).id}
    assert_response :success
  end
end
