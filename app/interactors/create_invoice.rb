require_relative "./base"
require_relative "../models/invoice"
require_relative "../models/line_item"
require_relative "../models/money"

module Interactor
  class CreateInvoice < Base
    register_boundary :order_gateway, -> { OrderMapper.new }
    register_boundary :customer_gateway, -> { CustomerMapper.new }

    def run
      customer = customer_gateway.find request.customer_id
      orders = order_gateway.find_by_month_and_customer_id request.month, request.customer_id
      line_items = orders.map do |o|
        o.offerings.map do |of|
          LineItem.new date: o.date, name: of.name, price: of.price, count: 1
        end
      end.flatten

      invoice = Invoice.new month: request.month, line_items: line_items, customer: customer
      OpenStruct.new object: invoice
    end
  end
end
