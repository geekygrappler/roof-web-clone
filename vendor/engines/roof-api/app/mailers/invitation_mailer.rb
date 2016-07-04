class InvitationMailer < ApplicationMailer
  include Rails.application.routes.url_helpers
  include RoofApi::Engine.routes.url_helpers
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.invitation_mailer.invite.subject
  #
  def invite invitation
    @invitation = invitation

    mail({
      from: invitation.inviter.email,
      to: invitation.invitee_attributes['email'],
      subject: I18n.t('invitation_mailer.invite.subject', {
          first_name: invitation.inviter.user.profile.first_name,
          project_name: invitation.project.name,
        })
    })
  end
end
