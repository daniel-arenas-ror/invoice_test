module Api
  class UsersController < Api::BaseController
    before_action :set_user, only: %i[show update destroy]

    def index
      users = User.all

      render json: UserSerializer.new(users).serializable_hash
    end

    def create
      persist(User.new(user_params), :created)
    end

    def show
      render json: UserSerializer.new(@user).serializable_hash
    end

    def update
      @user.assign_attributes(user_params)
      persist(@user, :ok)
    end

    def destroy
    end

    private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :phone, :email)
    end

    def persist(user, status)
      if user.save
        render json: UserSerializer.new(user).serializable_hash, status: status
      else
        render json: { errors: user.errors }, status: :unprocessable_content
      end
    end
  end
end
