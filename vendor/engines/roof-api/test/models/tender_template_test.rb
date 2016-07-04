require 'test_helper'

class TenderTemplateTest < ActiveSupport::TestCase
  test "validates" do
     assert tender_templates(:one).valid?
     refute tender_templates(:invalid).valid?
  end
end
