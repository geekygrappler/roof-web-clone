# Preview all emails at http://localhost:3000/rails/mailers/activity_mailer
class ActivityMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/activity_mailer/notify
  def notify
    ActivityMailer.notify
  end

end
