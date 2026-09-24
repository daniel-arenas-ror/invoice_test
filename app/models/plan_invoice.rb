class PlanInvoice < ApplicationRecord
  belongs_to :user
  belongs_to :plan

  enum :payment_status, { pending: 0, paid: 1, failed: 2 }
end
