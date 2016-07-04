class Charge < Composable::Model

  include StripeTools

  CURRENCY = 'gbp'.freeze

  attr_accessor :id

  def persisted?
    !!id
  end

  def create payment
    @object, error = with_stripe_error_handlers do
      Stripe::Charge.create(
        :amount => payment.amount, # in cents
        :currency => CURRENCY,
        :customer => payment.customer.stripe_customer.id,
        :metadata => {"payment_id" => id},
        :destination => payment.professional.stripe_account.id,
        :application_fee => payment.fee,
        #:idempotency_key => StripeTools.gen_idempotency_key('payment_id', payment.id)
      )
    end
    if error.nil?
      self.id = object.id
    else
      errors.add(:id, error)
    end
    self
  end

  def attributes
    {id: nil}
  end

  private

  def object
    @object ||= begin
      if id.present?
        object, error = with_stripe_error_handlers do
          Stripe::Charge.retrieve(id)
        end
        error.nil? && object
      end
    end
  end
end
