require_dependency 'Appointment'
require_dependency 'Payment'
require_dependency 'Activity'

class Notify
  def self.create_activities

    Appointment.upcoming(1.week).find_each do |appointment|
      Activity.create(actor: appointment, action: 'upcoming', subject: appointment)
    end

    Payment.due.find_each do |payment|
      Activity.create(actor: payment, action: 'due', subject: payment)
    end

    Payment.will_be_deposited_in(1.week).find_each do |payment|
      Activity.create(actor: payment, action: 'will_be_deposited', subject: payment)
    end
  end
end
