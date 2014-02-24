class MainController < ApplicationController
  def show
    @orders = #OrderMapper.new.find_by_date(Date.today)
    @orders = DB["SELECT orders.* FROM orders WHERE date = ?", Date.today].map do |o|
      offerings = DB["SELECT offerings.*, menus.name FROM offerings, order_items, menus WHERE order_items.order_id = ? AND offerings.id = order_items.offering_id AND menus.id = offerings.menu_id", o[:id]].all.map do |o|
        m = Menu.new(name: o[:name])
        Offering.new menu: m
      end

      Order.new(state: o[:state], date: o[:date], id: o[:id], offerings: offerings)
    end
  end
end
