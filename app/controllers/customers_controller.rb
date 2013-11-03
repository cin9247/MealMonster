require_relative "../interactors/create_customer"

class CustomersController < ApplicationController
  def index
    @customers = organization.customers
  end

  def new
    @customer = organization.new_customer
  end

  def create
    @customer = organization.new_customer customer_params

    response = Interactor::CreateCustomer.new(@customer).run

    if response.success?
      redirect_to customers_path, notice: "Customer successfully created"
    else
      flash[:error] = "There was an error submitting your request"
      render :new
    end
  end

  def show
    @customer = organization.find_customer_by_id params[:id]
  end

  private
    def customer_params
      params.require(:customer).permit(:forename, :surname)
    end
end
