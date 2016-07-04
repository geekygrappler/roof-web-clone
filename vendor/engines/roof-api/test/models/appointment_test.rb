require 'test_helper'

class AppointmentTest < ActiveSupport::TestCase
  test "appointmentable" do
    assert_equal appointments(:one).host, users(:custom)
    assert_equal appointments(:one).attendant, users(:pro)

    assert_equal appointments(:two).host, users(:pro2)
    assert_equal appointments(:two).attendant, users(:custom2)
  end
  test "cannot be created in the past" do
    refute appointments(:inthepast).valid?
  end
end
