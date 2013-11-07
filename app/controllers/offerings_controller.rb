class OfferingsController < ApplicationController
  def index
    from, to = parse_dates_or_default_to_next_week
    response = Interactor::ListOfferings.new(from, to).run

    @days = response.object.group_by do |o|
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
      value[:menus].each do |menuPosition, value|
        meal_ids = value[:meal_ids].map(&:to_i)
        Interactor::CreateOffering.new(date, meal_ids).run
      end
    end

    redirect_to offerings_path
  end

  private
    def parse_dates_or_default_to_next_week
      if params[:from] && params[:to]
        parse_from_to params
      else
        next_week
      end
    end

    def parse_from_to(params)
      [Date.parse(params[:from]), Date.parse(params[:to])]
    end

    def next_week
      [Date.today.next_week(:monday), Date.today.next_week(:sunday)]
    end
end
