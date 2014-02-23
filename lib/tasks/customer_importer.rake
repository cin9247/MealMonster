require "customer_importer"

namespace :customers do
  task :import => :environment do
    CustomerImporter.new("spec/fixtures/Adressen.txt", CustomerMapper.new).import!
  end
end
