class MainController < ApplicationController
  def show
    @orders = OrderMapper.new.find_by_date(Date.today)
  end
end
