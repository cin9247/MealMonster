require 'simplecov'
SimpleCov.start 'rails'

# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'capybara/rails'

Capybara.javascript_driver = :webkit

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean_with :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  config.include ApiHelper, example_group: { file_path: /spec\/features\/api/ }
end

def create_meal(name="Schweineschnitzel", kilojoules=1000, bread_units=2.1)
  request = OpenStruct.new(name: name, kilojoules: kilojoules, bread_units: bread_units)
  Interactor::CreateMeal.new(request).run.object
end

def create_customer(forename="Max", surname="Mustermann", note="Ich bin einsam.")
  request = OpenStruct.new(forename: forename, surname: surname, note: note)
  Interactor::CreateCustomer.new(request).run.object
end

def create_customer_with_town(forename, surname, town, note="Einsam")
  c = create_customer(forename, surname, note)
  request = OpenStruct.new(customer_id: c.id, street_name: "", street_number: "", postal_code: "12345", town: town)
  Interactor::AddAddressToCustomer.new(request).run
  ## TODO this can be solved by using an identity map
  CustomerMapper.new.find c.id
end

def create_tour(name, customer_ids)
  request = OpenStruct.new(name: name, customer_ids: customer_ids)
  Interactor::CreateTour.new(request).run.object
end

def create_ticket(title, body, customer_id)
  request = OpenStruct.new(title: title, body: body, customer_id: customer_id)
  Interactor::CreateTicket.new(request).run.object
end

def close_ticket(ticket_id)
  request = OpenStruct.new(ticket_id: ticket_id)
  Interactor::CloseTicket.new(request).run.object
end

def create_price_class(name="Preisklasse 1", price=Money.new(2031, 'EUR'))
  pc = PriceClass.new(name: name, price: price)
  PriceClassMapper.new.save pc
  pc
end

def create_offering(date, name="Menu", meal_ids=nil)
  meal_ids = meal_ids || (1..3).to_a.map do
    create_meal.id
  end
  price_class = create_price_class
  request = OpenStruct.new(name: name, date: date, meal_ids: meal_ids, price_class_id: price_class.id)
  Interactor::CreateOffering.new(request).run.object
end

def create_offering_with_price_class(date, name="Menu", meal_ids, price_class_id)
  request = OpenStruct.new(name: name, date: date, meal_ids: meal_ids, price_class_id: price_class.id)
  Interactor::CreateOffering.new(request).run.object
end

def create_driver(name)
  create_user name, name, "driver"
end

def set_driver_for_tour(driver_id, tour_id)
  request = OpenStruct.new(driver_id: driver_id, tour_id: tour_id)
  Interactor::SetDriverForTour.new(request).run.object
end

def create_admin(name, password)
  create_user(name, password, "admin")
end

def create_user(name, password, role)
  request = OpenStruct.new(name: name, password: password)
  user = Interactor::RegisterUser.new(request).run.object
  request = OpenStruct.new(user_id: user.id, role: role)
  Interactor::SetRole.new(request).run
  user
end

def add_key_for_customer(customer, name)
  request = OpenStruct.new(address_id: customer.address.id, name: name)
  Interactor::AddKeyToAddress.new(request).run
end

def create_order(customer_id, *offering_ids)
  date = OfferingMapper.new.find(offering_ids.first).date
  request = OpenStruct.new(customer_id: customer_id, offering_ids: offering_ids, date: date)
  Interactor::CreateOrder.new(request).run.object
end

def link_user_to_customer(user_id, customer_id)
  request = OpenStruct.new(customer_id: customer_id, user_id: user_id)
  Interactor::LinkUserToCustomer.new(request).run
end

def create_catchment_area(name="Krankenhaus")
  c = CatchmentArea.new(name: name)
  CatchmentAreaMapper.new.save c
  c
end

def deliver_order(order_id)
  request = OpenStruct.new(order_id: order_id)
  Interactor::Deliver.new(request).run
end

def load_order(order_id)
  request = OpenStruct.new(order_id: order_id)
  Interactor::Load.new(request).run
end

def login_with(user, password)
  visit "/login"

  fill_in "Username", with: user
  fill_in "Password", with: password

  click_on "Login"
end

def login_as_admin_basic_auth
  create_admin "admin", "admin"
  login_with_api "admin", "admin"
end

def login_with_api(user, password)
  basic_authorize user, password
end

def login_as_admin_web
  create_admin "admin", "admin"
  login_with "admin", "admin"
end
