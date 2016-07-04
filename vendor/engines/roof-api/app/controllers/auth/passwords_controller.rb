class Auth::PasswordsController < Devise::PasswordsController
  clear_respond_to
  respond_to :json

  before_filter :auth_xhr!

  # GET /resource/password/new
  def new
    render nothing: true, status: :not_found
  end

  # POST /resource/password
  # def create
  #   super
  # end

  # GET /resource/password/edit?reset_password_token=abcdef
  def edit
  render nothing: true, status: :not_found
  end

  # PUT /resource/password
  # def update
  #   super
  # end

  # protected

  # def after_resetting_password_path_for(resource)
  #   super(resource)
  # end

  # The path used after sending reset password instructions
  # def after_sending_reset_password_instructions_path_for(resource_name)
  #   super(resource_name)
  # end
end
