class PlanInvoiceSerializer
  include JSONAPI::Serializer
  attributes :invoice_date
  has_one :plan
end
