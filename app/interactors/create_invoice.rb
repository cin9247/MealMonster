require_relative "./base"
require_relative "../models/invoice"
require_relative "../models/line_item"
require_relative "../models/money"

module Interactor
  class CreateInvoice < Base
    register_boundary :order_gateway, -> { OrderMapper.new }

    def run
      orders = order_gateway.find_by_month request.month
      line_items = orders.map do |o|
        o.offerings.map do |of|
          LineItem.new date: o.date, name: of.name, price: of.price
        end
      end.flatten

      invoice = Invoice.new month: request.month, line_items: line_items
      OpenStruct.new object: invoice
    end
  end
end
