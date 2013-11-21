class CustomersController < ApplicationController
  def index
    @customers = wrap organization.customers
  end

  def new
    @customer = organization.new_customer
  end

  def create
    response = Interactor::CreateCustomer.new(customer_params[:forename], customer_params[:surname]).run

    if response.success?
      address_params = params[:customer][:address]
      Interactor::AddAddressToCustomer.new(response.object.id, address_params[:street_name], address_params[:street_number], address_params[:postal_code], address_params[:town]).run
      redirect_to customers_path, notice: "Customer successfully created"
    else
      @customer = response.object
      flash[:error] = "There was an error submitting your request"
      render :new
    end
  end

  def show
    @customer = wrap organization.find_customer_by_id(params[:id])
  end

  private
    def customer_params
      params.require(:customer).permit(:forename, :surname)
    end
end
