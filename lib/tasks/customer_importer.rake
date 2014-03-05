require "customer_importer"

namespace :customers do
  task :import => :environment do
    DB[:customers].delete
    DB[:addresses].delete
    DB[:tours].delete
    DB[:customers_tours].delete
    DB[:catchment_areas].delete
    CustomerImporter.new("spec/fixtures/Adressen.txt", CustomerMapper.new, TourMapper.new, CatchmentAreaMapper.new).import!
  end

  task :dummy_orders => :environment do
    today = Date.today
    offering = create_offering(today, "Dummy-Menu")

    CustomerMapper.new.fetch.each do |c|
      request = OpenStruct.new(date: today, customer_id: c.id, offering_ids: [offering.id])
      Interactor::CreateOrder.new(request).run
    end
  end
end

def create_offering(date, name="Menu", meal_ids=nil)
  meal_ids = meal_ids || (1..3).to_a.map do
    create_meal.id
  end
  price_class = create_price_class
  request = OpenStruct.new(name: name, date: date, meal_ids: meal_ids, price_class_id: price_class.id)
  Interactor::CreateOffering.new(request).run.object
end

def create_meal(name="Schweineschnitzel", kilojoules=1002, bread_units=2.1)
  request = OpenStruct.new(name: name, kilojoules: kilojoules, bread_units: bread_units)
  Interactor::CreateMeal.new(request).run.object
end

def create_price_class(name="Preisklasse 1", price=Money.new(2031, 'EUR'))
  pc = PriceClass.new(name: name, price: price)
  PriceClassMapper.new.save pc
  pc
end
