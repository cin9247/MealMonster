require 'offering_importer'

class OfferingsController < ApplicationController
  def index
    range = parse_dates_or_default_to_this_week
    response = interact_with :list_offerings, range

    @days = range.to_a

    @offerings = response.object.group_by do |o|
      o.date
    end
  end

  def new
    range = parse_dates_or_default_to_next_week

    @price_classes = PriceClassMapper.new.fetch
    @dates = range.to_a
  end

  def edit
    @offering = OfferingMapper.new.find params[:id].to_i
    @price_classes = PriceClassMapper.new.fetch
  end

  def update
    @offering = OfferingMapper.new.find params[:id].to_i
    price_class = PriceClassMapper.new.find params[:offering][:price_class_id].to_i
    @offering.price_class = price_class
    @offering.menu.name = params[:offering][:name]

    OfferingMapper.new.update @offering

    redirect_to offerings_path
  end

  def create
    params[:date].each do |index, date|
      date = Date.parse(date)

      [1, 2].each do |menu_index|
        next if params[:"name_#{menu_index}"][index].blank?

        meal_ids = params[:"meal_#{menu_index}"][index].map do |index, meal_name|
          if meal_name.present?
            request = OpenStruct.new(name: meal_name, kilojoules: 2, bread_units: 4)
            interact_with(:create_meal, request).object.id
          end
        end.compact

        request = OpenStruct.new(meal_ids: meal_ids, name: params[:"name_#{menu_index}"][index], date: date, price_class_id: params[:"price_class_id_#{menu_index}"][index].to_i)
        interact_with :create_offering, request
      end
    end

    dates = params[:date].map { |index, date| Date.parse(date) }
    redirect_to offerings_path(from: dates.first, to: dates.last)
  end

  def new_import
  end

  def import
    offering_mapper = OfferingMapper.new
    menu_mapper = MenuMapper.new
    price_class = PriceClass.new(name: "Random Preis", price: Money.new(2032))

    PriceClassMapper.new.save price_class

    offerings = OfferingImporter.new(params[:file].path).import!

    dates = offerings.map(&:date).uniq
    do_offerings_exist = dates.map do |d|
      offering_mapper.fetch_by_date d
    end.any? { |array| !array.empty? }

    if do_offerings_exist
      redirect_to new_import_offerings_path, notice: "Dieser Speiseplan ist schon importiert worden."
      return
    end

    offerings.each do |o|
      menu_mapper.save o.menu
      o.price_class = price_class
      offering_mapper.save o
    end

    first_date = offerings.map(&:date).min
    last_date = offerings.map(&:date).max
    redirect_to offerings_path(from: first_date, to: last_date)
  end
end
