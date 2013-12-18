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

def create_meal(name="Schweineschnitzel")
  Interactor::CreateMeal.new(name, 1000, 2.1).run.object
end

def create_customer(forename="Max", surname="Mustermann")
  Interactor::CreateCustomer.new(forename, surname).run.object
end

def create_customer_with_town(forename, surname, town)
  c = create_customer(forename, surname)
  Interactor::AddAddressToCustomer.new(c.id, "", "", "12345", town).run
  ## TODO this can be solved by using identity map
  CustomerMapper.new.find c.id
end

def create_tour(name, customer_ids)
  Interactor::CreateTour.new(name, customer_ids).run.object
end

def create_offering(date)
  meal_ids = (1..3).to_a.map do
    create_meal.id
  end
  Interactor::CreateOffering.new("Menu", date, meal_ids).run.object
end

def create_user(name, password)
  user = Interactor::RegisterUser.new(name, password).run.object
  Interactor::AddRole.new(user.id, "admin").run
  user
end

def login_as_admin
  create_user "admin", "admin"
  basic_authorize "admin", "admin"
end
