class ToursController < ApplicationController
  def index
    range = parse_dates_or_default_to_this_week
    @days = range.to_a.map do |date|
      tours = interact_with(:list_tours, OpenStruct.new(date: date)).object
      tours.each do |t|
        request = OpenStruct.new(tour_id: t.id, date: date)
        stations = interact_with :list_stations, request
        t.stations = stations
      end
      OpenStruct.new tours: tours, date: date
    end
  end

  def manage
    @customers = customers_to_hash CustomerMapper.new.fetch

    @tours = Interactor::ListTours.new(nil).run.object.map do |t|
      customers = customers_to_hash t.customers
      {
        id: t.id,
        name: t.name,
        customers: customers
      }
    end
  end

  def update
    DB[:customers_tours].delete
    params[:tours].each do |index, tour|
      customers = (tour[:customers] || []).map do |position, customer|
        CustomerMapper.new.find(customer[:id].to_i)
      end

      if tour[:id].present?
        t = TourMapper.new.find tour[:id].to_i
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
