# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require File.expand_path("../../../roof-web/config/environment.rb",  __FILE__)
# ActiveRecord::Migrator.migrations_paths = [File.expand_path("../../../roof-web/db/migrate", __FILE__)]
ActiveRecord::Migrator.migrations_paths << File.expand_path('../../db/migrate', __FILE__)
require "rails/test_help"
require 'stripe_mock'

# Filter out Minitest backtrace while allowing backtrace from other libraries
# to be shown.
Minitest.backtrace_filter = Minitest::BacktraceFilter.new

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

if ActiveSupport::TestCase.respond_to?(:fixture_path=)
  ActiveSupport::TestCase.fixture_path = File.expand_path("../fixtures", __FILE__)
  ActionDispatch::IntegrationTest.fixture_path = ActiveSupport::TestCase.fixture_path
  ActiveSupport::TestCase.fixtures :all
end

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  # fixtures :all

  # Add more helper methods to be used by all tests here...
  def valid_customer_account
    @valid_customer_account ||= Account.create(email: "validcustomer@email.com", password: 'password',
      user_attributes: {
        type: 'Customer',
        profile: {
          first_name: 'Jon',
          last_name: 'Doh',
          phone_number: '09999999999'
        }
      }
    )
  end
end

class ActionController::TestCase
  include Devise::TestHelpers
  setup do
    @routes = RoofApi::Engine.routes
    @request.env["devise.mapping"] = Devise.mappings[:account]
  end
end
