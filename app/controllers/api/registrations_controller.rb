module Api
  class RegistrationsController < Api::BaseController
    def create
      user = User.new(email: params[:email].downcase, password: params[:password], name: params[:name])

      if user.save
        token = JwtService.encode({ sub: user.id.to_s, eamil: user.email }, audience: "admin")
        render json: { token: token, user: user }, status: :created
      else
        render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end
end
