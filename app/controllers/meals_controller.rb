class MealsController < ApplicationController
  def index
    @meals = KITCHEN.meals
  end
end
