class ProfessionalsController < ResourceController

  def show
    if @record.stripe_account.id.nil?
      @record.stripe_account_create
      @record.save
    end
    render json: @record, serializer: serializer
  end


  protected

  def set_records
    super
    if params[:project_id]
      ids = Project.find(params[:project_id]).professionals.pluck(:user_id)
      @records = @records.where(id: ids)
    end
  end

  def permitted_attributes
    [
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
          :new_appointment,
          :new_payment,
          :new_project,
          :payment_approved,
          :payment_canceled,
          :payment_paid,
          :quote_accepted,
          :welcome,
          :new_comment
        ]
      },
      {
        stripe_account: [
          {
            updates: [
              :business_logo,
              :business_name,
              :business_primary_color,
              :business_url,
              :debit_negative_balances,
              {
                decline_charge_on: [
                  :avs_failure,
                  :cvc_failure
                ]
              },
              :default_currency,
              :email,
              {
                external_account: [
                  :object,
                  :account_number,
                  :country,
                  :currency,
                  :account_holder_name,
                  :account_holder_type,
                  :routing_number
                ]
              },
              {
                legal_entity: [
                  {
                    additional_owners: [
                      {
                        address: [
                          :city,
                          :country,
                          :line1,
                          :line2,
                          :postal_code,
                          :state
                        ]
                      },
                      {
                        dob: [
                          :day,
                          :month,
                          :year
                        ]
                      },
                      :first_name,
                      :last_name,
                      :identity_document, # this is the file to upload to stripe and returns id of it to be set on verification[:document] field
                    ]
                  },
                  {
                    address: [
                      :city,
                      :country,
                      :line1,
                      :line2,
                      :postal_code,
                      :state
                    ]
                  },
                  :business_name,
                  :business_tax_id,
                  :business_vat_id,
                  {
                    dob: [
                      :day,
                      :month,
                      :year
                    ]
                  },
                  :first_name,
                  :last_name,
                  :gender,
                  :maiden_name,
                  {
                    personal_address: [
                      :city,
                      :country,
                      :line1,
                      :line2,
                      :postal_code,
                      :state
                    ]
                  },
                  :personal_id_number,
                  :phone_number,
                  :type,
                  :identity_document, # this is the file to upload to stripe and returns id of it to be set on verification[:document] field
                  {
                    tos_acceptance: [
                      :date,
                      :ip,
                    ]
                  },
                  {
                    transfer_schedule: [
                      :delay_days,
                      :interval,
                      :monthly_anchor,
                      :weekly_anchor
                    ]
                  }
                ]
              }
            ]
          }
        ]
      }
    ]
  end

end
