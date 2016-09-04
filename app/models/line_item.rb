class LineItem < ActiveRecord::Base
  include PgSearch
  include CsvReset
  belongs_to :line_item
  belongs_to :location
  belongs_to :section
  has_many :line_items

  before_save :calculate_total
  after_save :calculate_section_totals

  pg_search_scope :full_text_search, :against => :name

  private

  def calculate_section_totals
    # triggers section.calculate_totals
    section.save unless section.nil?
  end

  def calculate_total
    self.total = quantity.to_i * rate.to_i
  end
end
