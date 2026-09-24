# Tests sign tokens with a throwaway key so they never depend on the real one.
ENV["OWL_JWT_PRIVATE_KEY"] = OpenSSL::PKey::RSA.new(2048).to_pem

module AuthHelpers
  def auth_headers(user)
    token = JwtService.encode({ sub: user.id.to_s }, audience: "admin")
    { "Authorization" => "Bearer #{token}" }
  end

  def json
    response.parsed_body
  end
end

RSpec.configure do |config|
  config.include AuthHelpers, type: :request
end
