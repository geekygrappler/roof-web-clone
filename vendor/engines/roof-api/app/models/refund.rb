class Refund < Composable::Model

  include StripeTools

  attr_accessor :id

  def persisted?
    !!id
  end

  def create charge
    @object, error = with_stripe_error_handlers do
      Stripe::Refund.create(
        :charge => charge.id,
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
          Stripe::Refund.retrieve(id)
        end
        error.nil? && object
      end
    end
  end
end
