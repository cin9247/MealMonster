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

  def edit
    @meal = kitchen.find_meal_by_id params[:id]
  end

  def update
    meal = kitchen.find_meal_by_id params[:id]
    meal.attributes = params[:meal]
    meal.offer!

    redirect_to meals_path
  end
end
