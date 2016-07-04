class Auth::RegistrationsController < Devise::RegistrationsController
  clear_respond_to
  respond_to :json

  before_filter :auth_xhr!
  before_filter :configure_sign_up_params, only: [:create]
  # before_filter :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  def new
    render nothing: true, status: :not_found
  end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  def edit
    render nothing: true, status: :not_found
  end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  def sign_up_params
    sign_up_params = devise_parameter_sanitizer.sanitize(:sign_up)
    # normalize user param for accepts_nested_attributes_for
    if sign_up_params[:user]
      sign_up_params[:user_attributes] = sign_up_params.delete(:user)
    end
    sign_up_params
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    # type is a must to go forward to determine what params required for user type
    # render nothing: true, status: :bad_request and return unless params[:account].try(:[], :user).try(:[], :type)
    # let's make it easier for clients, set Customer as default user type
    unless params[:account].try(:[], :user).try(:[], :type)
      params[:account] && params[:account][:user] && params[:account][:user][:type] = 'Customer'
    end
    devise_parameter_sanitizer.for(:sign_up) << {
      user: [:type, {profile: params[:account].try(:[],:user).try(:[],:type).try(:constantize).try(:required_profile_attributes)}]
    }
  end


  # def account_update_params
  #   account_update_params = devise_parameter_sanitizer.sanitize(:account_update)
  #   # normalize user param for accepts_nested_attributes_for
  #   if account_update_params[:user]
  #     account_update_params[:user_attributes] = account_update_params.delete(:user)
  #   end
  #   puts "-------> account_update_params #{account_update_params.inspect}"
  #
  #   account_update_params
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.for(:account_update) << {
  #     user: [{profile: current_account.user.profile.attributes.keys}]
  #   }
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end

  def prevent_administrator_registration
    render nothing: true, status: :bad_request if params[:account].try(:[], :user).try(:[], :type) == 'Administrator'
  end
end
