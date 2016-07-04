class PaymentIndexSerializer < ActiveModel::Serializer
  cache key: 'payments', compress: true, expires_in: 3.hours
  attributes :id,
    :status,
    :fee,
    :amount,
    :due_date,

    :approved_at,
    :paid_at,
    :canceled_at,
    :declined_at,
    :refunded_at,

    :project_id,
    :quote_id,
    :professional_id,
    :customer_id,

    :created_at,
    :updated_at

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
