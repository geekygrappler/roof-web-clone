class AppointmentIndexSerializer < ActiveModel::Serializer
  cache key: 'appointments', compress: true, expires_in: 3.hours
  attributes :id, :time, :project_id, :host_id, :host_type, :attendant_id, :attendant_type, :created_at, :updated_at
  # belongs_to :host
  # belongs_to :attendant
end
