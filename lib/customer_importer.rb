require "csv"
require_relative "../app/models/customer"
require_relative "../app/models/address"

class CustomerImporter
  def initialize(filename, customer_gateway)
    @filename = filename
    @customer_gateway = customer_gateway
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
      @customer_gateway.save Customer.new(attributes)
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

end


