class OrdersController < ApplicationController
  def index
    @orders = organization.orders
  end

  def new
    @customers = organization.customers
    @order = organization.day(params[:date]).new_order
    @offerings = organization.day(params[:date]).offerings
  end

  def create
    customer = organization.find_customer_by_id(params[:order][:customer_id].to_i)
    offering = organization.find_offering_by_id(params[:order][:offering_id].to_i)
    order = organization.day(params[:order][:date]).new_order customer: customer, offering: offering
    order.place!

    redirect_to orders_path
  end
end
