class MenusController < ApplicationController
  def index
    @menus = kitchen.menus
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
