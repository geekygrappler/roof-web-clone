require 'test_helper'

class AccountTest < ActiveSupport::TestCase
  test "validates user" do
    ['Customer', 'Professional', 'Administrator'].each do |user_type|
      account = Account.create(email: "#{user_type}@email.com", password: 'password',
        user_attributes: {
          type: user_type,
        }
      )
      refute account.persisted?
    end
  end
  test "registrable" do
    ['Customer', 'Professional'].each do |user_type|
      account = Account.create(email: "#{user_type}@email.com", password: 'password',
        user_attributes: {
          type: user_type,
          profile: {
            first_name: 'blah',
            last_name: 'blah',
            phone_number: 'blah'
          }
        }
      )

      assert account.persisted?
      assert account.user.persisted?
      assert account.user.is_a?(user_type.constantize)
      assert_equal user_type, account.user_type
    end
  end
end
