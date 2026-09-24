class AddEnumStatusToPlanInvoice < ActiveRecord::Migration[8.1]
  def change
    add_column :plan_invoices, :payment_status, :integer, default: 0
  end
end
