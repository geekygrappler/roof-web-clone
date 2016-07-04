class AdministratorsController < ResourceController


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
          :welcome,
          :new_comment
        ]
      },
    ]
  end

end
