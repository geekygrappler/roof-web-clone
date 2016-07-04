class ApiController < ActionController::API
  include ActionController::Cookies
  include ActionController::RequestForgeryProtection

  protect_from_forgery with: :exception

  before_action :store_ip

  force_ssl if: :ssl_configured?

  alias_method :current_user, :current_account

  protected

  def store_ip
    RequestStore.store[:ip] ||= request.ip
  end

  def auth_xhr!
    render nothing: true, status: :bad_request and return unless request.xhr?
  end

  def ssl_configured?
   Rails.env.production?
  end
end
