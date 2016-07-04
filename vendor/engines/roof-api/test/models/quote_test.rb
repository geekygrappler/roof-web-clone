require 'test_helper'

class QuoteTest < ActiveSupport::TestCase
  test "validates" do
    assert quotes(:one).valid?
    refute quotes(:two).valid?
  end
end
