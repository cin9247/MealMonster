module Interactor
  class ListOfferings
    attr_writer :offering_gateway, :day_source

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

      def day_source
        @day_source ||= Day.public_method(:new)
      end
  end
end
