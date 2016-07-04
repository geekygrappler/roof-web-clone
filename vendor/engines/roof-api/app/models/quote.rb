class Quote < ActiveRecord::Base
  include Accountable
  include BooleanAt
  include Acl
  belongs_to :tender
  belongs_to :professional, required: true, validate: true, class_name: 'Professional'
  belongs_to :project, required: true, validate: true, autosave: true
  has_many :payments, dependent: :nullify

  store_accessor :data,
    :submitted_at,
    :accepted_at,
    :migration,

    :insurance_amount,
    :guarantee_length,
    :summary

  boolean_at :submitted, :accepted

  before_validation :clone, on: :create, if: 'tender_id?'
  before_destroy :prevent_destroy, if: 'accepted?'
  # before_create :aggregate_prices
  before_create :apply_professional_prices
  validate :validate_project
  validates_uniqueness_of :professional_id, scope: :project_id
  validates_presence_of :insurance_amount, :guarantee_length, :summary, if: 'submitted?'
  validates_numericality_of :total_amount, greater_than: 0, if: 'submitted?'


  scope :search, ->(query) { where('data::text ilike ?', "%#{query}%")}

  ##
  # generates methods like quote.approved_amount, quote.paid_fee, ...
  [:approved, :paid, :refunded, :declined].each do |state|
    [:amount, :fee].each do |prop|
      define_method("#{state}_#{prop}") do
        payments.public_send("is_#{state}").sum("(data->>'#{prop}')::int") || 0
      end
    end
  end

  def accept
    if update(accepted_at: DateTime.now)
      create_activity project.account, 'accept', self
    end
  end

  def submit params = {}
    set_total_amount
    project.add_to_professionals professional
    if update(params.merge(submitted_at: DateTime.now))
      create_activity professional, 'submit', self
    end
  end

  private

  # def aggregate_prices
  #   document.items('tasks').map do |task|
  #     if task['id'] && prices = self.class.aggregate_prices(task['id'], professional_id).to_a[0]
  #       task['price'] = prices['avg_rate'].to_i
  #     end
  #   end
  # end

  def apply_professional_prices
    document.items('tasks').map do |task|
      if task['id'] && price = self.class.last_price(task['id'], professional_id).to_a[0]
        if price['price'].to_i > 0
          task['price'] = price['price'].to_i
        end
      end
    end
  end


  def clone
    self.document = tender.document.as_json
  end

  def validate_project
    if project && professional
      unless (project.account_id == professional.id ||
             project.professionals_member?(professional))

         errors.add(:project, "is not accessible")
      end
    end
  end

  def prevent_destroy
    errors.add(:base, :has_accepted)
    false
  end
end
