class CsvReference < ActiveRecord::Base
  belongs_to :database_objectable, polymorphic: true
  before_save :generate_key

  private

  def generate_key
    self.key = SecureRandom.urlsafe_base64
    generate_key if CsvReference.exists?(key: self.key)
  end
end
