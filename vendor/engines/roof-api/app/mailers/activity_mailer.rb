class ActivityMailer < ApplicationMailer

  def notify notification
    @notification = notification

    mail({
      from: parse_emails(notification[:from]),
      to: parse_emails(notification[:to]),
      subject: I18n.t(notification[:name], scope: 'activity_mailer.notify.subjects'),
      template_path: 'notifications',
      template_name: notification[:name]
    })
  end

  protected

  def parse_emails object
    [Account, User, Customer, Professional, Administrator].include?(object.class) ? (object.try(:account).try(:email) || object.try(:email) || object) : (object.is_a?(String) ? object : object.map{ |o| parse_emails(o) })
  end
end
