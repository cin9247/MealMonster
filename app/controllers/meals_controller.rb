class MealsController < ApplicationController
  def index
    @meals = KITCHEN.meals
  end

  def new
    @meal = KITCHEN.new_meal
  end

  def create
    meal = KITCHEN.new_meal params[:meal]
    meal.offer!
    redirect_to meals_path
  end
end
