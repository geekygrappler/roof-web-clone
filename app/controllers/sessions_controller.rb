class SessionsController < ApplicationController
  def new
    @resource = Account.new()
  end

  def create
    resource = Account.where(email: params[:account][:email]).first
    correct = resource.valid_password?(params[:account][:password])
    if correct
      sign_in(Account, resource)
      redirect_to documents_path, resource: resource
    else
      redirect_to :back, alert: 'wrong password'
    end
  end


end
