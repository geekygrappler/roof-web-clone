class BuildingMaterial < ActiveRecord::Base
  include PgSearch
  belongs_to :building_material
  belongs_to :section
  belongs_to :location
  belongs_to :unit
  has_many :building_materials

  delegate :name, to: :unit, prefix: true, allow_nil: true
  delegate :name, to: :location, prefix: true, allow_nil: true

  before_save :check_supplied
  before_save :calculate_total
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

  # If this is a tender (second conditional), then non-supplied materials
  # can't have a price
  def check_supplied
    if !self.supplied? && self.section.document.document == nil
      self.price = nil
    end
  end

  def calculate_section_totals
    # triggers section.calculate_totals
    section.save unless section.nil?
  end

  def calculate_total
    self.total = price.to_i
  end
end
