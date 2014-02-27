class OrdersController < ApplicationController
  def index
    range = parse_dates_or_default_to_this_week
    @orders = range.to_a.map do |date|
      OrderMapper.new.find_by_date date
    end.flatten
    @first_day = range.to_a.first
    @last_day = range.to_a.last
  end

  def by_catchment_area
    date = parse_date_or_default_to_today
    request = OpenStruct.new date: date
    @orders = interact_with(:group_orders_by_catchment_area, request).object
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
    if params[:orders].blank?
      redirect_to orders_path
      return
    end

    params[:orders].each do |index, order_params|
      request = request_from_order_params order_params
      request.customer_id = params[:customer_id].to_i
      interact_with :create_order, request
    end
    date = params[:orders].map { |index, params| params[:date] }.first

    from = Date.parse(date).beginning_of_week
    to = Date.parse(date).end_of_week
    redirect_to orders_path(from: from, to: to), notice: "Bestellungen erfolgreich erstellt."
  end

  def cancel_form
    @order = OrderMapper.new.find params[:id].to_i
  end

  def cancel
    request = OpenStruct.new order_id: params[:id].to_i, reason: params[:reason]
    interact_with :cancel_order, request
    redirect_to orders_path, notice: "Bestellung erfolgreich storiniert."
  end

  private
    def request_from_order_params order_params
      OpenStruct.new(offering_ids: (order_params[:offering_id] || []).reject(&:blank?).map(&:to_i), date: Date.parse(order_params[:date]))
    end
end
