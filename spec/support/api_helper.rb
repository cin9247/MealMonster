module ApiHelper
  include Rack::Test::Methods

  def app
    MealsOnWheels::Application
  end
end
