require "csv"
require_relative "../app/models/customer"
require_relative "../app/models/address"
require_relative "../app/models/tour"
require_relative "../app/models/catchment_area"

class CustomerImporter
  def initialize(filename, customer_gateway, tour_gateway, catchment_area_gateway)
    @filename = filename
    @customer_gateway = customer_gateway
    @tour_gateway = tour_gateway
    @catchment_area_gateway = catchment_area_gateway
  end

  def catchment_areas
    {
      1 => "HAK-BTW-ATH",
      2 => "HAK-KUPF",
      3 => "HAK-TP",
      4 => "HAK-Wohnung2",
      5 => "HAK-Sonstiges",
      6 => "MM-EHS",
      7 => "MM-HAK",
      8 => "MM-KWH",
      9 => "HAK-Wohnung3",
      10 => "HAK-Wohnung4",
      11 => "HAK-Wohnung5",
      12 => "HAK-Wohnung6",
      13 => "HAK-Wohnung7",
      14 => "HAK-Wohnung8",
      15 => "HAK-BTW-HH"
    }
  end

  def import!
    saved_areas = {}
    catchment_areas.map do |id, name|
      ca = CatchmentArea.new name: name
      @catchment_area_gateway.save ca
      saved_areas[id] = ca
    end

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
        address: address,
        catchment_area: saved_areas[line["Adresskategorie"].to_i]
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


