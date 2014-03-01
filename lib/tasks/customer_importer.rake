require "customer_importer"
require_relative "../../spec/spec_helper"

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
