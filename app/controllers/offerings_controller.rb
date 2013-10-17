class OfferingsController < ApplicationController
  def index
    from, to =
      if params[:from] && params[:to]
        [Date.parse(params[:from]), Date.parse(params[:to])]
      else
        [Date.today, Date.today + 6.days]
      end

    response = Interactor::ListOfferings.new(from, to).run

    @days = response.object.group_by do |o|
      o.date
    end
  end

  def new
    from, to = if params[:from] and params[:to]
      [Date.parse(params[:from]), Date.parse(params[:to])]
    else
      start_of_next_week = Date.today.beginning_of_week + 7.days
      [start_of_next_week, start_of_next_week + 6.days]
    end
    @meals = kitchen.meals
    @days = organization.days(from..to)
  end

  def create
    params[:offerings].each do |date, value|
      menus = value[:menus].map do |menuPosition, value|
        meals = value[:meal_ids].map do |id|
          kitchen.find_meal_by_id id
        end
        kitchen.new_menu meals: meals
      end
      menus.each do |m|
        organization.day(date).offer! m
      end
    end

    redirect_to offerings_path
  end
end
