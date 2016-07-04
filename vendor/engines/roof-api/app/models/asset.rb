require 'uploaders/asset_uploader'

class Asset < ActiveRecord::Base
  IMAGE_CONTENT_TYPES = ['image/png', 'image/jpeg', 'image/gif']

  belongs_to :project
  mount_uploader :file, AssetUploader
  # use this if only one worker active
  # below makes impossible to re-process images if process fails somehow, eg: workers scaled to 0
  # store_in_background :file

  # more than one worker dyno on heroku? than below is the thing
  process_in_background :file

  validates :content_type, presence: true
  before_validation :update_file_attributes

  # scope :images, -> { where("data->'content_type' <@ ?", IMAGE_CONTENT_TYPES.to_json) }
  # scope :non_images, -> { where.not("data->'content_type' <@ ?", IMAGE_CONTENT_TYPES.to_json) }
  scope :images, -> { where(content_type: IMAGE_CONTENT_TYPES.to_json) }
  scope :non_images, -> { where.not.images }

  scope :search, ->(query) { where('file ilike ?', "%#{query}%")}

  store_accessor :meta, :migration

  private

  def update_file_attributes
    if file.present? && file_changed?
      self.content_type = file.content_type
      self.file_size = file.size
    end
  end
end
