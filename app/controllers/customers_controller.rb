class CustomersController < ApplicationController
  def index
    @customers = organization.customers
  end

  def new
    @customer = organization.new_customer
  end

  def create
    customer = organization.new_customer customer_params
    customer.subscribe!
    redirect_to customers_path
  end

  def show
    @customer = organization.find_customer_by_id params[:id]
  end

  private
    def customer_params
      params.require(:customer).permit(:forename, :surname)
    end
end
