class ModifyTenderTemplatesToBeSearchable < ActiveRecord::Migration
  def up
    ActiveRecord::Base.transaction do
      TenderTemplate.all.each do |tender_template|
        tender_template.data['searchable'] = false
        tender_template.save
      end
    end
  end

  def down
    ActiveRecord::Base.transaction do
      TenderTemplate.all.each do |tender_template|
        tender_template.data = tender_template.data.except(:searchable)
        tender_template.save
      end
    end
  end
end
