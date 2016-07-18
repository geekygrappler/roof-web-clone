require 'csv'
class Task < ActiveRecord::Base
  store_accessor :data,
    :action,
    :group,
    :name,
    :quantity,
    :unit,
    :price,
    :searchable,
    :tags

  # enum unit: {unitless: 0, m: 1, m2: 2, m3: 3}
  UNITS = %w(unitless m m2 m3)

  scope :is_searchable, -> { where('data @> ?', {:searchable => true}.to_json)}

  scope :search, ->(query) {
    # is_searchable
    where(%Q{
    (data->'action')::text ilike :query OR
    (data->'group')::text ilike :query OR
    (data->'name')::text ilike :query OR
    (data->'tags')::text ilike :query
    }, {query: "%#{query}%"})
  }

  [:name, :action, :group].each do |attr_name|
    scope :"by_#{attr_name}", ->(value) {
      is_searchable
      .where("data @> ?", {attr_name => value}.to_json)
    }
  end

  validates_presence_of :name, :action, :group, :quantity, :unit, :price
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
  
  def self.reset_all
    Task.destroy_all
    CSV.foreach(Rails.root.join("task_db.csv"), :headers => true) do |row|
      # 0 display in search
      # 1 display in quote - name
      # 2 group
      # 3 action
      # 4 description
      # 5 quantity
      # 6 unit
      # 7 searchable
      # 8 rate
      searchable = row[7] == 'Yes' ? true : false
      unit = row[6].nil? ? 'unitless' : row[6]
      data = {
          search_name: row[0],
          name: row[1],
          group: row[2],
          action: row[3],
          description: row[4],
          quantity: row[5],
          unit: unit,
          searchable: searchable,
          price: row[8]
      }
      Task.create(data: data)
    end
  end

  private

  def strip_strings
    self.action = self.action.try(:strip)
    self.group = self.group.try(:strip)
    self.name = self.name.try(:strip)
    self.tags = self.tags.map(&:strip) if self.tags.is_a?(Array)
  end

  def set_defaults
    self.action ||= 'Other'
    self.group ||= 'Other'
    self.quantity ||= 0
    self.unit ||= 'unitless'
    self.price ||= 0
    self.searchable ||= false
  end
end
