module Api
  class PlansController < Api::BaseController
    before_action :set_plan, only: %i[show update destroy]

    def index
      plans = paginate Plan.all

      render json: PlanSerializer.new(plans)
    end

    def create
      persist(Plan.new(plan_params), :created)
    end

    def show
      render json: PlanSerializer.new(@plan)
    end

    def update
      @plan.assign_attributes(plan_params)
      persist(@plan, :ok)
    end

    def destroy
    end

    private

    def set_plan
      @plan = Plan.find(params[:id])
    end

    def plan_params
      params.require(:plan).permit(:speed, :price)
    end

    def persist(plan, status)
      if plan.save
        render json: PlanSerializer.new(plan), status: status
      else
        render json: { errors: plan.errors }, status: :unprocessable_content
      end
    end
  end
end
