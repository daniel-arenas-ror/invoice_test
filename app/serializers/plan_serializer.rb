class PlanSerializer
  include JSONAPI::Serializer
  attributes :speed, :price
end
