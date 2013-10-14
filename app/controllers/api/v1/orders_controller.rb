class Api::V1::OrdersController < Api::V1::ApiController
  respond_to :json

  def create
    customer = organization.find_customer_by_id(params[:customer_id].to_i)
    offering = organization.find_offering_by_id(params[:offering_id].to_i)
    @order = organization.day(params[:date]).new_order customer: customer, offering: offering
    @order.place!

    respond_with @order, status: 201
  end
end
