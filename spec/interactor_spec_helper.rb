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

      def fetch_sparse
        all
      end

      def save item
        items << item
        id = item.id = rand(10_000)
      end

      def update item
        existing_item = find(item.id)
        items.delete existing_item
        items << item
      end

      def find(id)
        if id.is_a? Array
          id.map { |id| find(id) }
        else
          items.find { |i| i.id == id }
        end
      end
      alias_method :non_whiny_find, :find

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
