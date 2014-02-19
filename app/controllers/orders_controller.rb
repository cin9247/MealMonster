class OrdersController < ApplicationController
  def index
    range = parse_dates_or_default_to_this_week
    @orders = range.to_a.map do |date|
      OrderMapper.new.find_by_date date
    end.flatten
  end

  def new
    range = parse_dates_or_default_to_this_week
    params[:date] ||= Date.today.iso8601
    @days = range.to_a.map do |date|
      offerings = OfferingMapper.new.fetch_by_date(date)
      order = Order.new
      OpenStruct.new(date: date, offerings: offerings, order: order)
    end
    @customers = CustomerMapper.new.fetch
  end

  def create
    params[:orders].each do |index, order_params|
      request = request_from_order_params order_params
      request.customer_id = params[:customer_id].to_i
      interact_with :create_order, request
    end

    redirect_to orders_path
  end

  private
    def request_from_order_params order_params
      OpenStruct.new(offering_ids: (order_params[:offering_id] || []).reject(&:blank?).map(&:to_i), date: Date.parse(order_params[:date]))
    end
end
