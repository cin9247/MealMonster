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
    @meals = MealMapper.new.fetch
    @days = range.to_a
  end

  def create
    params[:offerings].each do |date, value|
      value[:menus].each do |menu_position, value|
        meal_ids = (value[:meal_ids] || []).map(&:to_i)
        price_class_id = value[:price_class_id].to_i

        if meal_ids.present?
          request = OpenStruct.new(name: value[:name], date: date, meal_ids: meal_ids, price_class_id: price_class_id)
          interact_with :create_offering, request
        end
      end
    end

    redirect_to offerings_path
  end
end
