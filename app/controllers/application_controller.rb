class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception

  force_ssl if: :ssl_configured?

  private

  def after_sign_in_path_for(resource)
    documents_path(resource)
  end

  def ssl_configured?
   Rails.env.production?
  end
end
