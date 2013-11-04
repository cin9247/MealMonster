require "ostruct"

module DummyGateway
  def dummy_gateway
    Class.new do
      def all
        items
      end

      def save item
        items << item
      end

      def find(id)
        items.find { |i| i.id == id }
      end

      private
        def items
          @items ||= []
        end
    end.new
  end
end

RSpec.configure do |config|
  config.include DummyGateway
end
