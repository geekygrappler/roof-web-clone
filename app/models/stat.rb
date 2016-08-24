class Stat < ActiveRecord::Base
  belongs_to :stat_type
  belongs_to :statable, polymorphic: true
  belongs_to :stat_referenceable, polymorphic: true
  has_one :stat_value
end
