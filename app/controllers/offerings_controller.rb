class OfferingsController < ApplicationController
  def index
    from, to = parse_dates_or_default_to_next_week
    response = Interactor::ListOfferings.new(OpenStruct.new(from: from, to: to)).run

    @days = (from..to).to_a

    @offerings = response.object.group_by do |o|
      o.date
    end
  end

  def new
    from, to = parse_dates_or_default_to_next_week

    @meals = kitchen.meals
    @days = organization.days(from..to)
  end

  def create
    params[:offerings].each do |date, value|
      value[:menus].each do |menu_position, value|
        meal_ids = (value[:meal_ids] || []).map(&:to_i)

        if meal_ids.present?
          request = OpenStruct.new(name: value[:name], date: date, meal_ids: meal_ids)
          Interactor::CreateOffering.new(request).run
        end
      end
    end

    redirect_to offerings_path
  end
end
