class Content::TemplatesController < ResourceController
  def self.model_name
    @model_name ||= 'Content::Template'
  end
  protected

  def permitted_attributes
    [
      :path, :locale, :format, :handler, :partial, :body
    ]
  end
end
