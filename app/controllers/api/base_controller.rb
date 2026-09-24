module Api
  class BaseController < ActionController::API
    include Rails::Pagination
  end
end
