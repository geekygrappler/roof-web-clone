$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "roof_api/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "roof_api"
  s.version     = RoofApi::VERSION
  s.authors     = ["Onur Uyar"]
  s.email       = ["me@onuruyar.com"]
  s.homepage    = "http://1roof.com"
  s.summary     = "1ROOF Api."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "4.2.5.1"
  s.add_dependency 'rails-api'
  # needs to be in app's Gemfile as it needs git
  # s.add_dependency 'active_model_serializers'
  s.add_dependency 'puma'
  s.add_dependency 'pg'
  s.add_dependency 'devise'
  s.add_dependency 'mini_magick'
  s.add_dependency 'carrierwave'
  s.add_dependency 'carrierwave_backgrounder'
  s.add_dependency 'json-schema'
  s.add_dependency 'stripe'
  s.add_dependency 'cancancan', '~> 1.10'
  s.add_dependency 'request_store'
  s.add_dependency 'verbs'
  s.add_dependency 'slack-notifier'
  s.add_dependency 'money'
  s.add_dependency 'monetize'
  s.add_dependency 'wicked_pdf'
  s.add_dependency 'wkhtmltopdf-heroku'

  s.add_development_dependency 'rails_12factor'
  s.add_development_dependency 'letter_opener'
  s.add_development_dependency 'stripe-ruby-mock'
end
