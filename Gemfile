source 'https://rubygems.org'
#source 'https://Urx7-1GrXUKKC-1LnfGi@gem.fury.io/onurroof/'
#source 'https://repo.fury.io/Urx7-1GrXUKKC-1LnfGi/onurroof/'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.5.1'
gem 'pg', '~> 0.15'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'jquery-rails'
gem 'turbolinks'
gem 'sdoc', '~> 0.4.0', group: :doc
gem 'puma'
gem 'font-awesome-rails'
gem 'active_model_serializers', github: "rails-api/active_model_serializers"

#gem 'roof_api', '0.0.6.fix6'
#gem 'roof_api', path: '../roof-api'
gem 'roof_api', path: 'vendor/engines/roof-api'
gem 'carrierwave', git: 'https://github.com/carrierwaveuploader/carrierwave.git'
gem 'carrierwave_backgrounder', git: 'https://github.com/pictrs/carrierwave_backgrounder.git'
gem 'fog-aws'
gem 'rails_12factor'
gem 'delayed_job_active_record'
gem 'clockwork'
# only for migration
# gem 'asset_sync'

gem 'wicked_pdf'

gem 'aws-sdk', '~> 2'

group :production do
  gem 'wkhtmltopdf-heroku'
end

group :development, :test do
  gem 'wkhtmltopdf-binary', '~> 0.12.3'
  gem 'byebug'
  gem "letter_opener"
end

group :development do
  gem 'web-console', '~> 2.0'
  gem 'spring'
end
