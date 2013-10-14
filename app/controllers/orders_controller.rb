class OrdersController < ApplicationController
  def index
    @orders = organization.orders
  end

  def new
    @customers = organization.customers
    @order = organization.day(params[:date]).new_order
    @menus = organization.day(params[:date]).offerings.map(&:menu)
  end

  def create
    customer = organization.find_customer_by_id(params[:order][:customer_id].to_i)
    menu = kitchen.find_menu_by_id(params[:order][:menu_id].to_i)
    order = organization.day(params[:order][:date]).new_order customer: customer, menu: menu
    order.place!

    redirect_to orders_path
  end
end
