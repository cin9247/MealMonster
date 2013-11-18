require_relative "./base"

module Interactor
  class ListOfferings < Base
    attr_writer :offering_gateway

    def initialize(from, to)
      @from, @to = from, to
    end

    def run
      result = (@from..@to).map do |date|
        offering_gateway.fetch_by_date(date)
      end.flatten
      OpenStruct.new :object => result
    end

    private
      def offering_gateway
        @offering_gateway ||= OfferingMapper.new
      end
  end
end
