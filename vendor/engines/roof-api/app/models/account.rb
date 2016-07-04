class Account < ActiveRecord::Base
  DEFAULT_USER_TYPE = 'Customer'

  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :trackable, :validatable

  belongs_to :user, validate: true, required: true, inverse_of: :account
  accepts_nested_attributes_for :user

  attr_readonly :user_type
  before_save :ensure_user_type
  after_create :ensure_user_account_id

  has_many :projects

  User.types.each do |user_type|
    define_method("#{user_type.underscore}?") { self.user_type == user_type }
  end

  scope :search, ->(query) { where('email ilike ?', "%#{query}%")}

  watch :after_create, 'self', 'create', 'self'

  scope :notify_for?, ->(notification) { joins(:user).where("users.data->'notification' @> ?", {notification => true}.to_json) }

  def notify_for? notification
    user.notify_for? notification
  end

  private

  def ensure_user_type
    self.user_type = user.try(:type) || DEFAULT_USER_TYPE
  end

  def ensure_user_account_id
    user.update_column(:account_id, id) if user.account_id.nil?
  end

end
