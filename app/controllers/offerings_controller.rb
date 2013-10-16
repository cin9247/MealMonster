class OfferingsController < ApplicationController
  def index
    from, to = if params[:date]
      params[:date].split("..").map { |d| Date.parse d }
    else
      [Date.today, Date.today + 6.days]
    end
    @days = organization.days(from..to)
  end

  def new
    @menu = kitchen.new_menu
  end

  def create
    menu = kitchen.new_menu menu_params
    menu.offer!
    redirect_to offerings_path
  end

  private
    def menu_params
      params.require(:menu).permit(:date, :meal_ids => [])
    end
end
