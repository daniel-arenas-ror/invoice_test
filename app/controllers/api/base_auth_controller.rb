module Api
  class BaseAuthController < Api::BaseController
    include JwtAuthenticatable

    before_action :authenticate_user!
  end
end
