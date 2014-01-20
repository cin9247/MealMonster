class MealsController < ApplicationController
  def index
    @meals = kitchen.meals
  end

  def new
    @meal = kitchen.new_meal
  end

  def create
    request = OpenStruct.new(name: meal_params[:name], kilojoules: meal_params[:kilojoules], bread_units: meal_params[:bread_units])
    response = interact_with :create_meal, request

    if response.success?
      redirect_to meals_path
    else
      @meal = response.object
      render :new
    end
  end

  def edit
    @meal = kitchen.find_meal_by_id params[:id]
  end

  def update
    meal = MealMapper.new.find(params[:id])
    meal.attributes = meal_params
    MealMapper.new.update meal

    redirect_to meals_path
  end

  private
    def meal_params
      params.require(:meal).permit(:name, :kilojoules, :bread_units)
    end
end
