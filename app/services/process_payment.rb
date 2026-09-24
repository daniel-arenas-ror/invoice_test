class ProcessPayment
  def self.process(invoice_id, **options)
    new(invoice_id, **options).process
  end

  def initialize(invoice_id, **options)
    @invoice = PlanInvoice.find(invoice_id)
    @options = options
  end

  def process
    ActiveRecord::Base.transaction do
      @invoice.update!(payment_status: :paid)
    end
  end
end
