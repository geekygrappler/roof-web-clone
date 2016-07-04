require 'test_helper'

class CustomerTest < ActiveSupport::TestCase
  setup do
    @stripe_helper = StripeMock.create_test_helper
    @customer = users(:custom)
    StripeMock.start
  end
  teardown do
    StripeMock.stop
  end
  test "has a stripe customer object" do
    @customer.stripe_customer.create(@stripe_helper.generate_card_token)
    @customer.save
    assert @customer.reload.stripe_customer.object
    @customer.destroy
    refute @customer.stripe_customer.id
  end
end
