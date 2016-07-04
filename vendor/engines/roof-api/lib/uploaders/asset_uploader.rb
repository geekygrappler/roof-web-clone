# encoding: utf-8
# require 'carrierwave/processing/mime_types'

class AssetUploader < CarrierWave::Uploader::Base

  # include CarrierWave::MimeTypes
  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  include ::CarrierWave::Backgrounder::Delay

  # Choose what kind of storage to use for this uploader:
  if Rails.env.production?
    storage :fog
  else
    storage :file
  end
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  #process :set_content_type
  #process :save_content_type_and_size_in_model

  # def save_content_type_and_size_in_model
  #   model.content_type = file.content_type if file.content_type
  #   model.file_size = file.size
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  version :thumb, if: :image? do
    process :resize_to_fill => [300, 300]
  end

  version :cover, if: :pdf? do
    process :convert_cover => :png

    def full_filename (for_file = model.source.file)
      super.chomp(File.extname(super)) + '.png'
    end
  end

  def convert_cover(format)
    manipulate! do |img| # this is ::MiniMagick::Image instance
      img.format(format.to_s.downcase, 0)
      img
    end
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_white_list
  #   %w(jpg jpeg gif png)
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

  protected

  def image?(new_file)
    new_file.content_type.start_with? 'image'
  end

  def pdf?(new_file)
    new_file.content_type == 'application/pdf'
  end

end
