class Professional < User
  include Composable

  class Profile < Composable::Model
    attr_accessor :first_name, :last_name, :phone_number,
    :info, :dob, :website, :image_url,
    :company_name, :company_info, :company_registration_number, :company_vat_number,
    :insurance_number, :insurance_amount,
    :guarantee_duration

    validates_presence_of :first_name, :last_name

    def full_name
      "#{first_name}" "#{last_name}"
    end

    def attributes
      {
        :first_name => nil,
        :last_name => nil,
        :phone_number => nil,
        :info => nil,
        :dob => nil,
        :image_url => nil,
        :website => nil,
        :company_name => nil,
        :company_info => nil,
        :company_registration_number => nil,
        :company_vat_number => nil,
        :insurance_number => nil,
        :insurance_amount => nil,
        :guarantee_duration => nil
      }
    end
  end

  required_profile_attributes :first_name, :last_name

  composables :address, :stripe_account, profile: {class_name: 'Professional::Profile'}

  has_many :quotes, dependent: :destroy
  has_many :payments, dependent: :nullify

  before_create :stripe_account_create, if: 'migration.nil? || migration.empty? || !migration["stripe_user_id"].present?'
  before_update :stripe_account_update, if: 'stripe_account.updates.present?'
  before_destroy :stripe_account_destroy
  delegate :create, :update, :destroy, to: :stripe_account, prefix: true

  # scope :search, ->(query) { where('data::text ilike ?', "%#{query}%")}
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
      payment_approved: true,
      payment_canceled: true,
      payment_paid: true,
      # payment_due: true,
      payment_will_be_deposited: true,
      # payment_refunded: true,
      quote_accepted: true,
      # quote_submitted: true,
      welcome: true,
      new_comment: true
    })
  end
end
