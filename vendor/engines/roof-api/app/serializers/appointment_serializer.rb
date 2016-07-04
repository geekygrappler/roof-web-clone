class AppointmentSerializer < ActiveModel::Serializer
  #cache key: 'appointment', compress: true, expires_in: 3.hours
  attributes :id, :time, :description
  belongs_to :host
  belongs_to :attendant
end
