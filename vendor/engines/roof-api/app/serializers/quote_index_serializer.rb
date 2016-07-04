class QuoteIndexSerializer < ActiveModel::Serializer
  cache key: 'quotes', compress: true, expires_in: 3.hours

  attributes :id,
  :status,
  :total_amount,
  :paid_amount,
  :refunded_amount,
  :approved_amount,

  :project_id,
  :professional_id,
  :tender_id,

  :accepted_at,
  :submitted_at,
  :created_at,
  :updated_at,

  :document

  belongs_to :professional, serializer: QuoteProfessionalSerializer

  def document
    object.document
  end


  # has_many :payments do
  #   if scope.customer?
  #     object.payments.is_approved
  #   else
  #     object.payments
  #   end
  # end

  def status
    if object.accepted?
      'accepted'
    elsif object.submitted?
      'submitted'
    else
      'waiting'
    end
  end

end
