class AccountsController < ResourceController

  protected

  def set_records
    super
    @records = @records.where(user_type: params[:user_type]) if params[:user_type]
    @records
  end

  def permitted_attributes
    [
      :email,
      :password,
      :current_password,
      :user_type,
      {
        user_attributes: [
          :type,
          {
            profile: [
              :first_name, :last_name, :phone_number,
              :info, :dob, :website,
              :company_name, :company_info, :company_registration_number, :company_vat_number,
              :insurance_number, :insurance_amount,
              :guarantee_duration
            ]
          },
          {
            notifications: [
              :added_to_professionals,
              :appointment_canceled,
              :lead,
              :new_appointment,
              :new_payment,
              :new_project,
              :payment_approved,
              :payment_canceled,
              :payment_paid,
              :payment_refunded,
              :quote_accepted,
              :quote_submitted,
              :welcome
            ]
          }
        ]
      }
    ]
  end

end
