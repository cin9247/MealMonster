class OrdersController < ApplicationController
  def index
    @orders = organization.orders
  end
end
