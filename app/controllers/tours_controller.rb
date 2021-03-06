class ToursController < ApplicationController
  def index
    date = parse_date_or_default_to_today
    # TODO: add ListTours which return the driver and the tour names
    tours = DB[:tours].all.map do |t|
      tour_id = t[:id]
      tour_name = t[:name]
      driver = UserMapper.new.non_whiny_find t[:driver_id]
      request = OpenStruct.new(tour_id: tour_id, date: date)
      response = interact_with(:list_stations, request).object
      OpenStruct.new(name: tour_name, stations: response.stations, driver: driver, id: tour_id)
    end
    @day = OpenStruct.new tours: tours, date: date
  end

  def show
    date = Date.parse(params[:date])
    request = OpenStruct.new(tour_id: params[:id].to_i, date: date)
    @date = date
    tour = DB[:tours].where(id: request.tour_id).first
    @tour_name = tour[:name]
    @driver = UserMapper.new.non_whiny_find tour[:driver_id]
    response = interact_with(:list_stations, request).object
    @stations = response.stations
    @menu_summary = response.stations.map { |s| s.order.offerings }.flatten.group_by(&:id).map do |id, offerings|
      OpenStruct.new(name: offerings.first.name, count: offerings.size)
    end
  end

  def new
    @tour = Tour.new
  end

  def destroy
    name = DB[:tours].where(id: params[:id].to_i).first[:name]
    DB[:tours].where(id: params[:id].to_i).delete
    redirect_to manage_tours_path, notice: "Tour #{name} erfolgreich gelöscht."
  end

  def create
    if params[:tour][:name].blank?
      @tour = Tour.new
      flash.now[:error] = "Sie müssen einen Namen vergeben."
      render :new
      return
    end
    request = OpenStruct.new(name: params[:tour][:name], customer_ids: [])
    tour = interact_with(:create_tour, request).object
    redirect_to manage_tour_path(tour.id)
  end

  def manage
    if params[:id].blank?
      tour = DB[:tours].first
      redirect_to manage_tour_path(tour[:id])
      return
    end

    @customers = customers_to_hash CustomerMapper.new.fetch

    @drivers = UserMapper.new.fetch.select { |u| u.has_role? :driver }

    @all_tours = DB[:tours].all
    @tours = [TourMapper.new.find(params[:id].to_i)].map do |t|
      customers = customers_to_hash t.customers
      driver_hash = if t.driver
        {
          id: t.driver.id,
          name: t.driver.name
        }
      else
        nil
      end

      {
        id: t.id,
        name: t.name,
        customers: customers,
        driver: driver_hash
      }
    end
  end

  def update
    params_tours = params[:tours] ? params[:tours].values : []
    committed_tour_ids = params_tours.map { |p| p[:id] }.reject { |id| id.blank? }.compact

    DB[:customers_tours].where(:tour_id => params[:id].to_i).delete

    params_tours.each do |tour|
      customers = (tour[:customers] || []).map do |position, customer|
        CustomerMapper.new.find(customer[:id].to_i)
      end

      if tour[:id].present?
        if tour[:driver].present?
          request = OpenStruct.new(driver_id: tour[:driver][:id].to_i, tour_id: tour[:id].to_i)
          interact_with :set_driver_for_tour, request
        else
          request = OpenStruct.new(tour_id: tour[:id].to_i)
          interact_with :remove_driver_from_tour, request
        end
        t = TourMapper.new.find tour[:id].to_i
        t.customers = customers
        t.name = tour[:name]
        TourMapper.new.update t
      else
        t = interact_with(:create_tour, OpenStruct.new(customer_ids: customers.map(&:id), name: tour[:name])).object
        if tour[:driver].present?
          request = OpenStruct.new(driver_id: tour[:driver][:id].to_i, tour_id: t.id)
          interact_with :set_driver_for_tour, request
        end
      end
    end
    head 204
  end

  private
    ## TODO move to representer
    def customer_to_hash(c)
      {
        id: c.id,
        full_name: c.full_name,
        short_address: CustomerPresenter.new(c).short_address
      }
    end

    def customers_to_hash(customers)
      customers.map do |c|
        customer_to_hash c
      end
    end
end
