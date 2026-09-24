class ProcessPaymentJob < ApplicationJob
  queue_as :default

  def perform(plan_invoice_id)
    ProcessPayment.process(plan_invoice_id)
  end
end
