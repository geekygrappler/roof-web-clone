class LeadsController < ResourceController
  protected

  def permitted_attributes
    if current_account.try(:administrator?)
      [
        :first_name, :last_name, :phone_number, :email, :password,
        {
          meta: [
            :source,
            :glcid,
            :project_kind,
            :utm_referrer
          ]
        }
      ]
    else
    [
      :first_name, :last_name, :phone_number,
      {
        meta: [
          :source,
          :glcid,
          :project_kind,
          :utm_referrer
        ]
      }
    ]
    end
  end
end
