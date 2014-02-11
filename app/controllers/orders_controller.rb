class OrdersController < ApplicationController
  def index
    @orders = OrderMapper.new.fetch
  end

  def new
    params[:date] ||= Date.today.iso8601
    @date = Date.parse(params[:date])
    @customers = CustomerMapper.new.fetch
    @order = Order.new
    @offerings = OfferingMapper.new.fetch_by_date(@date)
  end

  def create
    request = OpenStruct.new(customer_id: params[:order][:customer_id].to_i, offering_ids: params[:order][:offering_id].reject(&:blank?).map(&:to_i))
    interact_with :create_order, request

    redirect_to orders_path
  end
end
