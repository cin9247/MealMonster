class MenusController < ApplicationController
  def index
    from, to = if params[:date]
      params[:date].split("..").map { |d| Date.parse d }
    else
      [Date.today, Date.today + 6.days]
    end
    @days = kitchen.days(from..to)
  end

  def new
    @menu = kitchen.new_menu
  end

  def create
    menu = kitchen.new_menu params[:menu]
    menu.offer!
    redirect_to menus_path
  end
end
