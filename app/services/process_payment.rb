class ProcessPayment
  def self.process(invoice_id, **option)
    new(invoice_id, **option).process
  end

  def initializer(invoice_id)
    @invoice = PlanInvoice.find(invoice_id)
  end

  def process
    Base:Transaction.transaction do
      @invoice.update(payment_status: :paid)
    end
  end
end
