require 'test_helper'

class PaymentsControllerTest < ActionController::TestCase
  setup do
    @stripe_helper = StripeMock.create_test_helper
    StripeMock.start

    # complete pro's account
    @pro = users(:pro)
    @pro.stripe_account_create
    @pro.update(stripe_account: {
      updates: {
        legal_entity: {
          type: "individual",
          first_name: 'Jon',
          last_name: 'Doe',
          dob: {
            month: '12',
            day: '1',
            year: '1983'
          },
          address: {
            line1: "No 71, Bethnal Green Road",
            postal_code: 'E2 7PR',
            city: "London",
            state: "London"
          }
        },
        external_account: {
          object:'bank_account',
          country: 'GB',
          currency: 'gbp',
          routing_number: '110000000',
          account_number: '000123456789'
        },
        tos_acceptance: {
          date: DateTime.now.to_i.to_s,
          ip: '10.0.0.1'
        }
      }
    })
  end
  teardown do
    StripeMock.stop
  end
  test "pro creates" do
    sign_in accounts(:acc_pro)

    assert_difference('Payment.count') do
      xhr :post, :create, {format: :json, payment: {
        project_id: projects(:one).id,
        professional_id: @pro.id,
        quote_id: quotes(:one).id,
        amount: 10,
        due_date: DateTime.now + 1.day,
        description: 'plesae pay!'
      }}
    end
    assert_response :success
  end

  test "pro cancels" do
    sign_in accounts(:acc_pro)
    payment = payments(:one)
    xhr :delete, :cancel, {format: :json, id: payment.id}
    assert payment.reload.canceled?
    assert_response :success
  end
  #
  test "admin approves" do
    sign_in accounts(:acc_admin)
    payment = payments(:waiting)
    xhr :put, :approve, {format: :json, id: payment.id, payment: {fee: 1}}
    assert payment.reload.approved?
    assert_response :success
  end
  test "admin refunds" do
    # TODO: add refund endpoint to StripeMock GEM!!!
    # sign_in accounts(:acc_admin)
    # payment = payments(:one)
    # xhr :post, :refund, {format: :json, id: payment.id}
    # assert payment.reload.refunded?
    # assert payment.refund.persisted?
    # assert_response :success
  end

  test "customer pays" do
    acc = accounts(:acc_custom)
    sign_in acc
    payment = payments(:one)
    payment.project.add_to_customers acc, true
    xhr :post, :pay, {format: :json, id: payment.id, token: @stripe_helper.generate_card_token}
    assert payment.reload.paid?
    assert payment.charge.persisted?
    assert_response :success
  end

end
