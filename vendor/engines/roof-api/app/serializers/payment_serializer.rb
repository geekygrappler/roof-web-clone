class PaymentSerializer < ActiveModel::Serializer
  #cache key: 'payment', compress: true, expires_in: 3.hours
  attributes :id,
    :approved_at,
    :paid_at,
    :canceled_at,
    :declined_at,
    :refunded_at,
    :fee,
    :amount,
    :due_date,
    :description,
    :charge,
    :refund,

    :project_id,
    :professional_id,
    :quote_id,
    :customer_id,

    :status

  def status
    if object.refunded?
      'refunded'
    elsif object.canceled?
      'canceled'
    elsif object.declined?
      'declined'
    elsif object.paid?
      'paid'
    elsif object.approved?
      'payable'
    else
      'waiting'
    end
  end

end
