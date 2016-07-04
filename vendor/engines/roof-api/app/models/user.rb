class User < ActiveRecord::Base

  class Profile < Composable::Model
    attr_accessor :first_name, :last_name, :phone_number
    validates_presence_of :first_name, :last_name, :phone_number
    def full_name
      "#{first_name}" "#{last_name}"
    end
    def attributes
      {
        :first_name => nil,
        :last_name => nil,
        :phone_number => nil
      }
    end
  end

  def self.types
    @@types ||= %w(Customer Professional Administrator)
  end

  def self.required_profile_attributes *attrs
    @required_profile_attributes ||= attrs
  end

  store_accessor :data, :notifications, :migration

  belongs_to :account, validate: true, inverse_of: :user, dependent: :destroy

  # don't allow generic User type here
  validates :type, inclusion: {in: types}
  attr_readonly :type

  has_many :attending_appointments, as: :attendant, class_name: 'Appointment'
  has_many :hosting_appointments, as: :host, class_name: 'Appointment'

  scope :notify_for?, ->(notification) { where("users.data->'notification' @> ?", {notification => true}.to_json) }

  def notify_for? notification
    notifications.try(:[], notification)
  end
end
