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
