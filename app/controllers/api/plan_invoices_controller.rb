module Api
  class PlanInvoicesController < Api::BaseAuthController
    before_action :set_user
    before_action :set_plan_invoice, only: %i[show update destroy]

    def index
      plans = paginate @user.plan_invoices

      render json: PlanInvoiceSerializer.new(plans)
    end

    def create
      persist(@user.plan_invoices.new(plan_params), :created)
    end

    def show
      render json: PlanInvoiceSerializer.new(@plan_invoice)
    end

    def update
      @plan_invoice.assign_attributes(plan_params)
      persist(@plan_invoice, :ok)
    end

    def destroy
    end

    private

    def set_user
      @user = User.find(params[:user_id])
    end

    def set_plan_invoice
      @plan_invoice = @user.plan_invoices.find(params[:id])
    end

    def plan_params
      params.require(:plan_invoice).permit(:invoice_date, :plan_id)
    end

    def persist(plan_invoice, status)
      if plan_invoice.save
        render json: PlanInvoiceSerializer.new(plan_invoice), status: status
      else
        render json: { errors: plan_invoice.errors }, status: :unprocessable_content
      end
    end
  end
end
