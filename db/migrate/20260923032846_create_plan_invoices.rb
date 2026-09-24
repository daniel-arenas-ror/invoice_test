class CreatePlanInvoices < ActiveRecord::Migration[8.1]
  def change
    create_table :plan_invoices do |t|
      t.date :invoice_date
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :plan, null: false, foreign_key: true

      t.timestamps
    end
  end
end
