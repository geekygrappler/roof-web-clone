class Project < ActiveRecord::Base
  include Composable
  include Membership

  def self.kinds
    @@kinds ||= %w(
    renovation
    redecoration
    kitchen
    bathroom
    extension
    other
  )
  end

  belongs_to :account, required: true, validate: true

  store_accessor :data, :name, :kind,
  :customers_ids, :shortlist_ids, :professionals_ids, :administrators_ids,
  :migration

  # NOTE: these memberships excepting Account model instead of User model like Customer or Professional
  composables :brief, :address
  membership :customers, :professionals, :administrators

  validates :kind, presence: true, inclusion: {in: kinds}

  before_save :set_default_name
  before_save :make_account_member

  validate :validate_memberships

  has_many :assets, dependent: :destroy
  accepts_nested_attributes_for :assets, allow_destroy: true, reject_if: :remove_new_assets
  attr_accessor :asset_ids

  after_save :reassign_new_assets
  before_create :assign_admin

  has_many :appointments, dependent: :destroy
  has_one :tender, dependent: :destroy
  has_many :quotes, dependent: :destroy
  has_many :payments, dependent: :nullify

  after_save :notify_members

  scope :search, ->(query) {
    customers_ids = Customer.search(query).pluck(:account_id)
    professionals_ids = Professional.search(query).pluck(:account_id)
    sql = ["data::text ilike :query"]
    sql << "data->'customers_ids' <@ :customers_ids" if customers_ids.any?
    sql << "data->'professionals_ids' <@ :professionals_ids" if professionals_ids.any?
    where(
      sql.join(' OR '),
      {
        customers_ids: customers_ids.to_json,
        professionals_ids: professionals_ids.to_json,
        query: "%#{query}%"}
    )
  }

  watch :after_create, 'account', 'create', 'self'

  private

  def notify_members
    if data_was
      if professionals_ids && data_was['professionals_ids']
        new_professionals_ids = professionals_ids - data_was['professionals_ids']
        if new_professionals_ids.any?
          new_professionals_ids.each do |id|
            create_activity Account.find(id), 'added_to_professionals', self
          end
        end
      end
    end
  end

  def set_default_name
    self.name = "My #{kind.titleize} Project" unless self.name.present?
  end

  def make_account_member
    self.public_send "add_to_#{account.user_type.tableize}", account
  end

  def validate_memberships
    User.types.each do |user_type|
      group = :"#{user_type.tableize}"
      errors.add(group, "members must be kind of #{user_type}") if public_send(group).where.not(user_type: user_type).any?
    end
  end

  def reassign_new_assets
    Asset.where(id: asset_ids).update_all(project_id: self.id)
  end

  def assign_admin
    if admin = Account.where(user_type: 'Administrator').where(id: [6,8]).order('RANDOM()').limit(1)[0]
      self.add_to_administrators admin
    end
  end

end
