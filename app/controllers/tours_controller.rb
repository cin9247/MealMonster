class ToursController < ApplicationController
  def index
    range = parse_dates_or_default_to_this_week
    @days = range.to_a.map do |date|
      tours = interact_with(:list_tours, OpenStruct.new(date: date)).object
      tours.each do |t|
        request = OpenStruct.new(tour_id: t.id, date: date)
        stations = interact_with :list_stations, request
        t.stations = stations.object
      end
      OpenStruct.new tours: tours, date: date
    end
  end

  def manage
    @customers = customers_to_hash CustomerMapper.new.fetch

    @drivers = UserMapper.new.fetch.select { |u| u.has_role? :driver }

    @tours = Interactor::ListTours.new(nil).run.object.map do |t|
      customers = customers_to_hash t.customers
      driver_hash = if t.driver
        {
          id: t.driver.id,
          name: t.driver.name
        }
      else
        {}
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
    TourMapper.new.only_keep_ids(committed_tour_ids)

    DB[:customers_tours].delete

    (params_tours).each do |tour|
      customers = (tour[:customers] || []).map do |position, customer|
        CustomerMapper.new.find(customer[:id].to_i)
      end

      if tour[:id].present?
        t = TourMapper.new.find tour[:id].to_i
        d = if tour[:driver]
          UserMapper.new.find tour[:driver][:id].to_i
        else
          nil
        end
        t.driver = d
        t.customers = customers
        t.name = tour[:name]
        TourMapper.new.update t
      else
        interact_with :create_tour, OpenStruct.new(customer_ids: customers.map(&:id), name: tour[:name])
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
