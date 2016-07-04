class CustomersController < ResourceController

  protected

  def permitted_attributes
    [
      {
        profile: [
          :first_name, :last_name, :phone_number
        ]
      },
      {
        notifications: [
          :appointment_canceled,
          :new_appointment,
          :new_payment,
          :new_project,
          :payment_canceled,
          :payment_refunded,
          :quote_submitted,
          :welcome,
          :new_comment
        ]
      }
    ]
  end

end
