require 'test_helper'

class ProfessionalTest < ActiveSupport::TestCase
  setup do
    @stripe_helper = StripeMock.create_test_helper
    StripeMock.start
    @pro = Account.create(
      email: "proaccount@email.com",
      password: 'password',
      user_attributes: {
        type: 'Professional',
        profile: {
          first_name: 'Jon',
          last_name: 'Doh',
          phone_number: '09999999999'
        }
      }
    ).user
    assert @pro.persisted?
  end
  teardown do
    StripeMock.stop
  end
  test "has a stripe customer object" do
    assert @pro.stripe_account
    @pro.update(stripe_account: {
      updates: {
        legal_entity: {
          first_name: 'Jon',
          last_name: 'Doe',
          dob: {
            month: '12',
            day: '1',
            year: '1983'
          }
        },
        tos_acceptance: {
          date: DateTime.now.to_i.to_s,
          ip: '10.0.0.1'
        }
      }
    })
    assert @pro.reload.stripe_account.object
    # NOTE: contribute to StripeMock gem and add delete v1/accounts/:id resource
    # @pro.destroy
    # refute @pro.stripe_account.id
  end
end
