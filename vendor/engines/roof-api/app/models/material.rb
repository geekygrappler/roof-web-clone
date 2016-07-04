class Material < ActiveRecord::Base
  store_accessor :data,
    :name,
    :quantity,
    :price,
    :supplied,
    :searchable,
    :tags

  scope :is_searchable, -> { where('data @> ?', {:searchable => true}.to_json)}

  scope :search, ->(query) {
    # is_searchable
    where(%Q{
    (data->'name')::text ilike :query OR
    (data->'tags')::text ilike :query
    }, {query: "%#{query}%"})
  }

  scope :by_name, ->(value) {
    is_searchable
    .where("data @> ?", {name: value}.to_json)
  }

  validates_presence_of :name, :quantity, :price
  validates_numericality_of :quantity, :price, only_integer: true

  after_initialize :set_defaults

  before_save :strip_strings

  def price=val
    write_store_attribute(:data, :price, val.to_money.cents)
  end

  def quantity=val
    write_store_attribute(:data, :quantity, val.to_i)
  end

  def searchable?
    public_send(:searchable)
  end

  private

  def strip_strings
    self.name = self.name.try(:strip)
    self.tags = self.tags.map(&:strip) if self.tags.is_a?(Array)
  end

  def set_defaults
    self.quantity ||= 0
    self.price ||= 0
    self.supplied ||= false
    self.searchable ||= false
  end
end
