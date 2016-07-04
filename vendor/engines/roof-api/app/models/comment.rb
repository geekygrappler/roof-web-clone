class Comment < ActiveRecord::Base
  belongs_to :account, required: true, validate: true
  belongs_to :commentable, polymorphic: true, required: true
  belongs_to :commentable_parent, polymorphic: true, required: true
  store_accessor :data, :text, :project_id
  validates_presence_of :text
  watch :after_create, 'account', 'create', 'self'
  def project
    @project ||= Project.find(project_id)
  end
end
