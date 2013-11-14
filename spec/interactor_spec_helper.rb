require "ostruct"

module DummyGateway
  def dummy_gateway
    Class.new do
      def all
        items
      end

      def fetch
        all
      end

      def save item
        items << item
      end

      def find(id)
        items.find { |i| i.id == id }
      end

      def method_missing(method, *args, &block)
        if method.to_s =~ /^find_by_(.+)$/
          value = args.first
          items.select { |i| i.send($1.to_sym) == value }
        else
          super
        end
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
