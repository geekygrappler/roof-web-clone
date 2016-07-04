class StripeCustomer < StripeUser

  def create token
    # don't create another customer if already exists
    errors.add(:id, :taken) and return self if self.id.present?

    @object, error = with_stripe_error_handlers do
      Stripe::Customer.create({:source => token})
    end
    if error.nil?
      self.id = object.id
    else
      errors.add(:id, error)
    end
    self
  end

end
