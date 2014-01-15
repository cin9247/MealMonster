class OrdersController < ApplicationController
  def index
    @orders = organization.orders
  end

  def new
    params[:date] ||= Date.today.iso8601
    @date = Date.parse(params[:date])
    @customers = organization.customers
    @order = organization.day(@date).new_order
    @offerings = OfferingMapper.new.fetch_by_date(@date)
  end

  def create
    request = OpenStruct.new(customer_id: params[:order][:customer_id], offering_id: params[:order][:offering_id])
    Interactor::CreateOrder.new(request).run

    redirect_to orders_path
  end
end
