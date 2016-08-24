class Document < ActiveRecord::Base
  belongs_to :document
  belongs_to :document_state
  belongs_to :user
  has_many :documents
  has_many :sections
end
