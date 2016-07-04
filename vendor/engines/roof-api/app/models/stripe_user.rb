class StripeUser < Composable::Model
  include StripeTools

  attr_accessor :id
  attr_reader :object

  def persisted?
    !!id
  end

  def create; raise UnimplementedError end

  def update; raise UnimplementedError end

  def destroy
    return true unless id
    @object, error = with_stripe_error_handlers do
      object.delete
    end
    if error.nil? && object.deleted
      self.id = nil
    else
      errors.add(:id, error || 'not deleted')
    end
    self
  end

  def attributes
    {id: nil}
  end

  def method_missing name, *args, &block
    if object.try(:respond_to?, name)
      object.public_send(name, *args, &block)
    else
      super
    end
  end

  def object
    @object = nil if persisted? && @object.is_a?(Hash)
    @object ||= begin
      if persisted?
        object, error = with_stripe_error_handlers do
          ("Stripe::#{self.class.name.gsub('Stripe','')}").constantize.retrieve(id)
        end
        if error.nil?
          object
        else
          Rails.logger.error "-----> Stripe user not found for id: #{self.id}"
          raise error.to_s
        end
      end
    end
  end

end
