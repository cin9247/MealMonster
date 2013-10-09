module ApiHelper
  include Rack::Test::Methods

  def app
    MealsOnWheels::Application
  end

  def json_response
    JSON.parse last_response.body
  end
end
