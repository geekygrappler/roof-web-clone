require 'validators/time_in_future_validator'
class Appointment < ActiveRecord::Base
  belongs_to :project, required: true, validate: true
  belongs_to :host, polymorphic: true, required: true, validate: true
  belongs_to :attendant, polymorphic: true, required: true, validate: true

  store_accessor :data, :time, :description
  validates :time, presence: true, time_in_future: true
  validate :validate_project

  watch :after_create, 'host', 'create', 'self'
  watch :before_destroy, 'host', 'destroy', 'self'

  scope :search, ->(query) { where('data::text ilike ?', "%#{query}%")}
  scope :upcoming, ->(time_span) {
    where(
      "(data->>'time')::timestamp >= ? AND (data->>'time')::timestamp <= ?",
      DateTime.now.beginning_of_day + time_span,
      DateTime.now.end_of_day + time_span
    )
  }

  private

  def validate_project
    if project
      if host.is_a?(Customer) && !project.customers_member?(host) ||
         host.is_a?(Professional) && !(project.professionals_member?(host))

         errors.add(:project, "is not accessible")
      end
    end
  end

end
