module ApiHelper
  include Rack::Test::Methods

  def app
    CareEAR::Application
  end

  def json_response
    JSON.parse last_response.body
  end
end
