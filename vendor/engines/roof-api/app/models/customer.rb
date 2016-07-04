class Customer < User
  include Composable
  required_profile_attributes :first_name, :last_name, :phone_number

  composables :stripe_customer, profile: {class_name: 'User::Profile'}

  has_many :payments

  before_destroy :stripe_customer_destroy
  delegate :destroy, to: :stripe_customer, prefix: true

  #scope :search, ->(query) { where('data::text ilike ?', "%#{query}%")}
  scope :search, ->(query) {where("to_tsvector(data::text) @@ tsquery(?)", query.gsub(/\s/,' | '))}

  after_initialize :set_default_notification_settings

  private

  def set_default_notification_settings
    self.notifications ||= HashWithIndifferentAccess.new({
      added_to_professionals: true,
      appointment_canceled: true,
      appointment_upcoming: true,
      # lead: true,
      new_appointment: true,
      new_payment: true,
      new_project: true,
      # payment_approved: true,
      payment_canceled: true,
      # payment_paid: true,
      payment_refunded: true,
      payment_due: true,
      # payment_will_be_deposited: true,
      # quote_accepted: true,
      quote_submitted: true,
      welcome: true,
      new_comment: true
    })
  end
end
