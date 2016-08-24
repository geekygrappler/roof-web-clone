class StateTypeSerializer < ActiveModel::Serializer
  attributes :id, :name, :metric, :calculation, :description
end
