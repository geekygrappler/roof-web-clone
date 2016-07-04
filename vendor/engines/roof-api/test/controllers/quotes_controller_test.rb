require 'test_helper'

class QuotesControllerTest < ActionController::TestCase

  test "customer can index" do
    sign_in accounts(:acc_custom)
    xhr :get, :index, {format: :json, project_id: projects(:one).id}
    assert_response :success
  end
  test "customer can show" do
    sign_in accounts(:acc_custom)
    xhr :get, :index, {format: :json, id: quotes(:one).id}
    assert_response :success
  end
  test "customer can accept" do
    sign_in accounts(:acc_custom)
    xhr :put, :accept, {format: :json, id: quotes(:one).id}
    assert_response :success
  end

  test "pro can create from scratch" do
    sign_in accounts(:acc_pro)
    assert_difference('Quote.count') do
      xhr :post, :create, {format: :json, quote: {
        project_id: projects(:one).id,
        professional_id: users(:pro).id,
        document: tender_templates(:one).data['document_attributes']
      }}
    end
    assert_response :success
  end

  test "pro can create by cloning a tender" do
    sign_in accounts(:acc_pro)
    assert_difference('Quote.count') do
      xhr :post, :create, {format: :json, quote: {
        project_id: projects(:one).id,
        professional_id: users(:pro).id,
        tender_id: tenders(:one).id
      }}
    end
    assert_response :success
  end

  test "pro can submit" do
    sign_in accounts(:acc_pro)
    xhr :put, :submit, {format: :json, id: quotes(:one).id}
    assert_response :success
  end
end
