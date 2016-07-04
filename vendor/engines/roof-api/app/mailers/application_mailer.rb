class ApplicationMailer < ActionMailer::Base
  prepend_view_path Content::Template::Resolver.instance
  include Rails.application.routes.url_helpers
  include RoofApi::Engine.routes.url_helpers

  default from: "noreply@1roof.com"
  layout 'mailer'
end
