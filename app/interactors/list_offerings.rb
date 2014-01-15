require_relative "./base"

module Interactor
  class ListOfferings < Base
    register_boundary :offering_gateway, -> { OfferingMapper.new }

    def run
      result = (request.from..request.to).map do |date|
        offering_gateway.fetch_by_date(date)
      end.flatten
      OpenStruct.new :object => result
    end
  end
end
