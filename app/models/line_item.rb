class LineItem < ActiveRecord::Base
  include PgSearch
  include TaskCsvReset
  belongs_to :line_item
  belongs_to :location
  belongs_to :section
  belongs_to :unit
  has_many :line_items

  delegate :name, to: :unit, prefix: true, allow_nil: true
  delegate :name, to: :location, prefix: true, allow_nil: true

  before_save :convert_material_cost, :calculate_total
  after_save :calculate_section_totals

  pg_search_scope :full_text_search,
                  :against => :name,
                  :using => {
                      :tsearch => {
                          :any_word => true,
                          :dictionary => 'english',
                          :prefix => true,
                          :highlight => true
                      }
                  }

  private

  def calculate_section_totals
    # triggers section.calculate_totals
    section.save unless section.nil?
  end

  def calculate_total
    self.total = quantity.to_i * rate.to_i + material_cost.to_i
  end

  def convert_material_cost
    self.material_cost =  Monetize.parse(material_cost, "GBP").cents
  end
end
