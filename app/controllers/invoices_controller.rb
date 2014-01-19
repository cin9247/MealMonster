class InvoicesController < ApplicationController
  def index
    @customer = CustomerMapper.new.find params[:customer_id].to_i
    @orders = OrderMapper.new.find_by_customer_id(@customer.id)
  end
end
