class FailedPayment < ActiveRecord::Base

  store_accessor :data, :payment_id, :message

end
