module StripeTools

  extend ActiveSupport::Concern

  module ClassMethods
    def idempotency_attribute attr_name = nil
      @idempotency_attribute ||= attr_name
    end
  end

  def with_stripe_error_handlers &block
    error = nil
    result = nil
    begin
      result = yield
    rescue Stripe::CardError => e
      # Since it's a decline, Stripe::CardError will be caught
      body = e.json_body
      err  = body[:error]

      puts %Q{
        Status is: #{e.http_status}"
        Type is: #{err[:type]}"
        Code is: #{err[:code]}"
        Param is: #{err[:param]}"
        Message is: #{err[:message]}"
      }
      error = err[:message]
    rescue Stripe::RateLimitError => e
      # Too many requests made to the API too quickly
      Rails.logger.error e.inspect + "\n" + e.backtrace.join("\n")
      error = e.message
    rescue Stripe::InvalidRequestError => e
      # Invalid parameters were supplied to Stripe's API
      Rails.logger.error e.inspect + "\n" + e.backtrace.join("\n")
      error = e.message
    rescue Stripe::AuthenticationError => e
      # Authentication with Stripe's API failed
      # (maybe you changed API keys recently)
      Rails.logger.error e.inspect + "\n" + e.backtrace.join("\n")
      error = e.message
    rescue Stripe::APIConnectionError => e
      # Network communication with Stripe failed
      Rails.logger.error e.inspect + "\n" + e.backtrace.join("\n")
      error = e.message
    rescue Stripe::StripeError => e
      # Display a very generic error to the user, and maybe send
      # yourself an email
      Rails.logger.error e.inspect + "\n" + e.backtrace.join("\n")
      error = e.message
    rescue => e
      # Something else happened, completely unrelated to Stripe
      Rails.logger.error e.inspect + "\n" + e.backtrace.join("\n")
      error = e.message
    end
    [result, error]
  end

  def idempotency_key
    # "#{self.class.name.underscore}_#{self.class.idempotency_attribute}__#{read_attribute(self.class.idempotency_attribute)}"
    @idempotency_key ||= self.class.gen_idempotency_key(self.class.idempotency_attribute, read_attribute(self.class.idempotency_attribute))
  end

  def update_recursive object, attributes_hash
    attributes_hash.each do |key, value|
      if value.is_a? Hash
        update_recursive object.public_send(key), value
      else
        object.public_send("#{key}=", value)
      end
    end
  end

  # purpose can be business_logo, dispute_evidence, identity_document, incorporation_article
  def stripe_upload_file purpose, file
    with_stripe_error_handlers do
      file_upload = Stripe::FileUpload.create(
        :purpose => purpose,
        :file => file
      )
      file_upload.id
    end
  end

  module_function

  def gen_idempotency_key key, value
    "#{self.name.underscore}_#{key}__#{value}"
  end
end
