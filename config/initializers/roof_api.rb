AssetUploader.class_eval do
  if Rails.env.production?
    storage :fog
  else
    storage :file
  end
end
