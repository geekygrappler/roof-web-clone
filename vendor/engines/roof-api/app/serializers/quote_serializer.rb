class QuoteSerializer < ActiveModel::Serializer
  #cache key: 'quote', compress: true, expires_in: 3.hours

  attributes :id, :document, :project_id, :professional_id, :accepted_at, :submitted_at, :total_amount, :tender_id,
  :approved_amount, :paid_amount, :refunded_amount, :declined_amount, :status,
  :insurance_amount, :guarantee_length, :summary, :comments_counts

  belongs_to :professional, serializer: QuoteProfessionalSerializer

  has_many :payments do
    if scope.customer?
      object.payments.is_approved
    else
      object.payments
    end
  end

  def status
    if object.accepted?
      'accepted'
    elsif object.submitted?
      'submitted'
    else
      'waiting'
    end
  end

  def comments_counts
    {
      tasks: counts('tasks'),
      materials: counts('materials')
    }
  end

  private

  def counts coll
    object.document.items(coll).map{ |task|
      {
        id: task['id'],
        comments_count: Comment.where({
          commentable_id: task['id'],
          commentable_type: coll.classify,
          commentable_parent_id: object.id,
          commentable_parent_type: 'Quote'
        }).count
      }
    }
  end

end
