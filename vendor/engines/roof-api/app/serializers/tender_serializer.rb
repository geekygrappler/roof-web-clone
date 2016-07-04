class TenderSerializer < ActiveModel::Serializer
  #cache key: 'tender', compress: true, expires_in: 3.hours
  attributes :id, :document, :project_id, :total_amount, :comments_counts
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
          commentable_parent_type: 'Tender'
        }).count
      }
    }
  end
end
