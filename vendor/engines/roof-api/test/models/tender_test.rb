require 'test_helper'

class TenderTest < ActiveSupport::TestCase
  test "needs project" do
    assert tenders(:one).valid?
    refute tenders(:two).valid?
    assert tenders(:three).valid?
  end
end
