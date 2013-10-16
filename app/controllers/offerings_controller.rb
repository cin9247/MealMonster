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
    @meals = kitchen.meals
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

  private
    def menu_params
      params.require(:menu).permit(:date, :meal_ids => [])
    end
end
