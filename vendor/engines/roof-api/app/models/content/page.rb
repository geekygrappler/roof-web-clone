class Content::Page < ActiveRecord::Base
  validates_presence_of :pathname, :body
  validates_uniqueness_of :pathname
  before_save :parameterize_pathname
  private
  def parameterize_pathname
    self.pathname ||= pathname.parameterize
  end
end
