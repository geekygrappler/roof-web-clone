class Lead < ActiveRecord::Base

  attr_accessor :email, :password

  store_accessor :data, :first_name, :last_name, :phone_number, :converted, :meta

  validates_presence_of :first_name, :last_name, :phone_number

  before_save :convert, if: 'email.present? && password.present? && !converted'

  scope :search, ->(query) { where('data::text ilike ?', "%#{query}%")}

  watch :after_create, 'self', 'create', 'self'

  def convert
    account = Account.create(email: email, password: password, user_attributes: {type: 'Customer', profile: {
      first_name: first_name,
      last_name: last_name,
      phone_number: phone_number
    }})
    unless account.persisted?
      account.errors.messages.each do |f, m|
        errors.add(f, m)
      end
      false
    else
      update(converted: true)
    end
  end


end
