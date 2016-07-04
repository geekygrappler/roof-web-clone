require 'test_helper'

class PaymentTest < ActiveSupport::TestCase
  setup do
    @stripe_helper = StripeMock.create_test_helper
    StripeMock.start
    @customer = users(:custom)
    @payment = payments(:one)
    @pro = payments(:one).professional
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
  test "validates" do
    assert @payment.valid?
    refute payments(:two).valid?
  end
  test "cannot exceed quote amount in total" do
    payment = payments(:highamount)
    refute payment.valid?
    assert payment.errors.keys.include? :amount
  end
  test "cannot have applied fee more than quote amount in total" do
    payment = payments(:highfee)
    refute payment.valid?
    assert payment.errors.keys.include? :fee
  end
  test "id approvable" do
    payment = payments(:waiting)
    assert payment.approve(1)
    assert payment.approved?
  end
  test "id cancelable" do
    payment = payments(:waiting)
    assert payment.cancel
    assert payment.canceled?
  end
  test "is payable with token for first time paying customer" do
    @payment.project.add_to_customers @customer.account
    result = @payment.pay @customer, @stripe_helper.generate_card_token
    assert result, 'should pe paid'
    assert @payment.paid?, 'should marked as paid'
    assert @payment.charge.persisted?, 'should have charge object'
  end
  test "is payable without token for already paying customer" do
    # identical with above as we need first payment with token
    @payment.project.add_to_customers @customer.account
    result = @payment.pay @customer, @stripe_helper.generate_card_token
    assert result, 'should pe paid'
    assert @payment.paid?, 'should marked as paid'
    assert @payment.charge.persisted?, 'should have charge object'

    payment = payments(:one_second_installment)
    payment.project.add_to_customers @customer.account
    result = payment.pay @customer
    assert result, 'should pe paid'
    assert payment.paid?, 'should marked as paid'
    assert payment.charge.persisted?, 'should have charge object'
  end
  test "is refundable" do
    # TODO: add refund endpoint to StripeMock so can be tested
    # @payment.project.add_to_customers @customer.account
    # result = @payment.pay @customer, @stripe_helper.generate_card_token
    # assert result, 'should pe paid'
    # assert @payment.reimburse, 'should refund'
    # assert @payment.refunded?, 'should status set to refunded'
  end
end
