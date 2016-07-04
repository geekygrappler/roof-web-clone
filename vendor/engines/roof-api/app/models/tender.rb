class Tender < ActiveRecord::Base
  include Accountable
  include Acl
  store_accessor :data, :migration
  belongs_to :tender_template
  belongs_to :project, required: true, validate: true
  has_many :quotes, dependent: :nullify

  attr_readonly :tender_template_id, :project_id
  before_validation :clone_template #, if: 'tender_template_id.present? && (migration.nil? || migration.empty?)'
  before_update :merge_with_template, if: 'tender_template_id.present? && merge.present?'

  validates_uniqueness_of :project_id
  scope :search, ->(query) { where('data::text ilike ?', "%#{query}%")}

  attr_accessor :merge

  private

  def clone_template
    if new_record? && tender_template_id.present? && (migration.nil? || migration.empty?)
      self.document = tender_template.document.as_json
    end
  end

  def merge_with_template

    # add new sections from template
    tender_template.document.sections.each do |tmp_section|
      unless self.document.sections.select{ |section| section['name'].downcase == tmp_section['name'].downcase}.first
        self.document.sections << tmp_section
      end
    end

    # merge sections with same names, also fix ids
    self.document.sections.each_with_index.map do |section, index|
      if tmp_section = tender_template.document.sections.select{ |tmp_section| section['name'].downcase == tmp_section['name'].downcase}.first

        section = tmp_section.deep_merge section
        tmp_section['tasks'].each do |task|
          unless section['tasks'].select{|_task| _task['id'] == task['id'] }.first
            section['tasks'] << task
          end
        end

        if tmp_section['materials']
          tmp_section['materials'].each do |material|
            section['materials'] ||= []
            unless section['materials'].select{|_material| _material['id'] == material['id'] }.first
              section['materials'] << material
            end
          end
        end
      end
      section['id'] = index
      section
    end
  end
end
