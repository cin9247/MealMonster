class MenusController < ApplicationController
  def index
    @menus = KITCHEN.menus
  end

  def new
    @menu = KITCHEN.new_menu
  end

  def create
    menu = KITCHEN.new_menu params[:menu]
    menu.offer!
    redirect_to menus_path
  end
end
