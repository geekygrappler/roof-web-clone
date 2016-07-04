class TenderTemplate < ActiveRecord::Base
  include Accountable
  store_accessor :data, :name, :migration
  validates :name, presence: true
  has_many :tenders, dependent: :nullify
  scope :search, ->(query) { where('data::text ilike ?', "%#{query}%")}
end
