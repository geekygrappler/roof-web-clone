class InvitationsController < ResourceController

  skip_before_filter :set_record, only: [:invite, :accept]

  def invite
    @record = self.class.model.invite(
      permitted_params[:project_id],
      permitted_params[:inviter_id],
      permitted_params[:invitee_attributes]
    )
    render(@record.persisted? ? record_response(:created) : errors_response)
  end

  def accept
    if @record = self.class.model.accept(permitted_params[:token], permitted_params[:invitee_attributes])
      if @record.invitee.try(:persisted?)
        sign_in @record.invitee
        render(record_response(:created))
      else
        @record = @record.invitee
        render(errors_response)
      end
    else
      render(json: {errors: {token:"invalid token"}}, status: 422)
    end
  end

  protected

  def permitted_attributes
    [
      :project_id, :inviter_id, :token,
      {
        invitee_attributes: [
          :user_type,
          :email,
          :password,
          {
            profile: [:first_name, :last_name, :phone_number]
          }
        ]
      }
    ]
  end
end
