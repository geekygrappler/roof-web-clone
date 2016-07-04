class Auth::SessionsController < Devise::SessionsController
  clear_respond_to
  respond_to :json

  before_filter :auth_xhr!
# before_filter :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  def new
    if current_account
      if session[:impersonator_id]
        render json: {account: AccountSerializer.new(current_account).as_json, impersonator_id: session[:impersonator_id]}
      else
        render json: current_account
      end
    else
      render nothing: true, status: :not_found
    end
  end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  def destroy
    session[:impersonate_id] = nil
    super
  end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.for(:sign_in) << :attribute
  # end

  def csrf_token
    response.headers['X-CSRF-Token'] = form_authenticity_token
    render json: nil
  end

  def impersonate
    if account = Account.find(params[:id])
      session[:impersonator_id] = current_account.id
      sign_in account
      render json: {account: AccountSerializer.new(current_account).as_json, impersonator_id: session[:impersonator_id]}
    end
  end

  def stop_impersonate
    if account = Account.find(session[:impersonator_id])
      session[:impersonator_id] = nil
      sign_in account
      render json: account
    end
  end

  private

  def respond_to_on_destroy
    head :no_content
  end
end
