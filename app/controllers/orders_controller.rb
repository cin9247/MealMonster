class OrdersController < ApplicationController
  def index
    @orders = organization.orders
  end

  def new
    params[:date] ||= Date.today
    @customers = organization.customers
    @order = organization.day(params[:date]).new_order
    @offerings = organization.day(params[:date]).offerings
  end

  def create
    Interactor::CreateOrder.new(params[:order][:customer_id].to_i, params[:order][:offering_id].to_i).run

    redirect_to orders_path
  end
end
