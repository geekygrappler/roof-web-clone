require 'validators/time_in_future_validator'
class Payment < ActiveRecord::Base

  DEFAULT_FEE_PERCENTAGE = 10

  include Composable
  include BooleanAt
  include Acl

  belongs_to :project, required: true, validate: true
  belongs_to :professional, required: true, validate: true
  belongs_to :quote, required: true, validate: true
  belongs_to :customer, validate: true

  store_accessor :data,
    :approved_at,
    :paid_at,
    :canceled_at,
    :declined_at,
    :refunded_at,
    :fee,
    :amount,
    :due_date,
    :description,
    :migration

  composables :charge, :refund

  boolean_at :approved, :paid, :canceled, :refunded, :declined

  validates_presence_of :amount, :due_date
  validates :due_date, time_in_future: true, on: :create, if: 'migration.nil? || migration.empty?'
  validates_numericality_of :amount, only_integer: true
  validate :validate_maximum_payable_amount, if: 'amount.present?'
  validates_numericality_of :fee, only_integer: true, if: 'approved?'
  validate :validate_maximum_fee, if: 'approved? && fee.present?'
  validate :validate_professional_stripe_account

  before_destroy :prevent_destroy, if: 'paid? || refunded?'

  scope :search, ->(query) { where('data::text ilike ?', "%#{query}%")}
  scope :due, -> {
    not_paid.not_refunded.not_canceled.is_approved
    .where("(data->>'due_date')::timestamp >= ?", DateTime.now.beginning_of_day)
  }
  scope :will_be_deposited_in, ->(time_span) {
    is_paid.
    where(
      "(data->>'paid_at')::timestamp >= ? AND (data->>'paid_at')::timestamp <= ?",
      DateTime.now.beginning_of_day - time_span,
      DateTime.now.end_of_day - time_span
    )
  }


  watch :after_create, 'professional', 'create', 'self'

  def fee=val
    write_store_attribute(:data, :fee, val.to_i * 100)
  end

  def amount=val
    write_store_attribute(:data, :amount, val.to_i * 100)
  end

  def maximum_payable_amount
    return 0 unless quote
    quote.total_amount - quote.paid_amount
  end

  def maximum_payable_fee
    return 0 unless quote
    # allow to capture all the payment as a app fee as there are some payments in old database with fee_percentage = %100
    amount # * DEFAULT_FEE_PERCENTAGE / 100
  end

  def due?
    DateTime.now > due_date
  end

  def approve fee
    if !paid? && !refunded?
      if update(approved_at: DateTime.now, fee: fee)
        create_activity project.account, 'approve', self
      end
    end
  end

  def cancel
    if !paid? && !refunded?
      if update(canceled_at: DateTime.now)
        create_activity professional, 'cancel', self
      end
    end
  end

  def pay paying_customer, token = nil
    begin
      validate_pay
      return false unless errors.empty?

      self.customer = validate_customer(paying_customer, token)
      return false unless errors.empty?

      charge.create(self)
      if charge.errors.empty?
        if update(paid_at: DateTime.now)
          create_activity customer, 'pay', self
        end
      else
        update(declined_at: DateTime.now)
        return false
      end

    rescue Exception => e
      Rails.logger.error e.inspect + "\n" + e.backtrace.join("\n")
      errors.add(:charge, e.message)
      return false
    end
  end

  def reimburse
    begin
      unless paid?
        errors.add(:base, :only_paid_payments_can_be_refund)
        return false
      end

      refund.create(charge)
      if refund.errors.empty?
        if update(refunded_at: DateTime.now)
          create_activity project.administrators.first, 'refund', self
        end
      else
        return false
      end
    rescue Exception => e
      Rails.logger.error e.inspect + "\n" + e.backtrace.join("\n")
      errors.add(:refund, e.message)
      return false
    end
  end

  private

  def prevent_destroy
    errors.add(:base, :has_paid_payments)
    false
  end

  def validate_maximum_payable_amount
    if amount > maximum_payable_amount
      errors.add(:amount, I18n.t(:less_than_or_equal, amount: maximum_payable_amount, scope: 'activerecord.errors.messages'))
    end
  end

  def validate_maximum_fee
    if fee > maximum_payable_fee
      errors.add(:fee, I18n.t(:less_than_or_equal, amount: maximum_payable_fee, scope: 'activerecord.errors.messages'))
    end
  end

  def validate_professional_stripe_account
    return unless professional
    if !professional.stripe_account.persisted?
      errors.add(:professional, :account_incomplete)
    elsif professional.stripe_account.object.verification.fields_needed.any?
      errors.add(:professional,
        I18n.t(:verification_needed, fields_needed: professional.stripe_account.verification.fields_needed, scope: 'activerecord.errors.messages')
      )
    end
  end

  def validate_pay
    errors.add(:charge, :only_approved_can_be_paid) unless persisted?
    errors.add(:charge, :only_approved_can_be_paid) unless approved?
    errors.add(:charge, :only_approved_can_be_paid) if canceled?
    errors.add(:charge, :only_approved_can_be_paid) if paid?
    errors.add(:charge, :only_approved_can_be_paid) if refunded?
    errors.add(:fee, :blank) unless fee
  end

  def validate_customer paying_customer, token
    unless project.customers_member?(paying_customer.account_id)
      errors.add(:customer, :not_a_member)
      return
    else
      unless paying_customer.stripe_customer.persisted?
        paying_customer.stripe_customer.create(token)
        if paying_customer.stripe_customer.errors.any?
          errors.add(:customer, paying_customer.stripe_customer.errors.full_messages)
          return
        else
          paying_customer.save
        end
      end
      paying_customer
    end
  end

end


