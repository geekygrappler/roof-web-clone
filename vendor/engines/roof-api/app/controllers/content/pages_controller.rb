class Content::PagesController < ResourceController
  def self.model_name
    @model_name ||= 'Content::Page'
  end
  protected

  def permitted_attributes
    [
      :pathname, :body
    ]
  end
end
