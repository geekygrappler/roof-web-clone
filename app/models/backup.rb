class Backup < ActiveRecord::Base
  belongs_to :document
  belongs_to :backup_type
end
