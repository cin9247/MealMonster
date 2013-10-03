class MealsController < ApplicationController
  def index
    @meals = kitchen.meals
  end

  def new
    @meal = kitchen.new_meal
  end

  def create
    meal = kitchen.new_meal params[:meal]
    meal.offer!
    redirect_to meals_path
  end
end
