require "customer_importer"

namespace :customers do
  task :import => :environment do
    DB[:customers].delete
    DB[:tours].delete
    DB[:customers_tours].delete
    DB[:catchment_areas].delete
    CustomerImporter.new("spec/fixtures/Adressen.txt", CustomerMapper.new, TourMapper.new, CatchmentAreaMapper.new).import!
  end
end
