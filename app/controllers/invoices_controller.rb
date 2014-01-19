class InvoicesController < ApplicationController
  def index
    @orders = OrderMapper.new.find_by_customer_id(params[:customer_id].to_i)
  end
end
