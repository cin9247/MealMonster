require "csv"
require_relative "../app/models/customer"
require_relative "../app/models/address"
require_relative "../app/models/tour"

class CustomerImporter
  def initialize(filename, customer_gateway, tour_gateway)
    @filename = filename
    @customer_gateway = customer_gateway
    @tour_gateway = tour_gateway
  end

  def import!
    CSV.foreach(@filename, headers: true, quote_char: '"', col_sep: ";") do |line|

      if line["Nachname"].blank? || line["PLZ"].blank? || line["Ort"].blank?
        next
      end

      street_name, street_number = split_street_name line["Straße"]
      attributes = {
        street_name: street_name,
        street_number: street_number,
        town: line["Ort"],
        postal_code: line["PLZ"]
      }
      address = Address.new attributes

      attributes = {
        prefix: line["Anrede"],
        forename: line["Vorname"],
        surname: line["Nachname"],
        note: line["Besondere_Wünsche"],
        telephone_number: line["Telefon"],
        address: address
      }
      customer = Customer.new(attributes)
      @customer_gateway.save customer

      add_tour line["TourWochentags"], customer, line["ReihenfolgeAnfahrt"].to_i
      add_tour line["TourSonnFeiertag"], customer, line["ReihenfolgeAnfahrtSonn"].to_i
    end

    tours.each do |name, customers|
      customers = customers.sort_by { |c| c[:position] }
      @tour_gateway.save Tour.new(name: name, customers: customers.map { |c| c[:customer] })
    end
  end

  private
    def split_street_name(street_name)
      if street_name =~ /\A(.*) (\d+)\Z/
        [$1, $2]
      else
        [street_name]
      end
    end

    def add_tour(name, customer, position)
      tours[name] << {customer: customer, position: position}
    end

    def tours
      @tours ||= Hash.new { |h, key| h[key] = [] }
    end

end


