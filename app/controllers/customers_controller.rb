class CustomersController < ApplicationController
  def index
    @customers = wrap organization.customers
  end

  def new
    @customer = organization.new_customer
  end

  def edit
    @customer = CustomerMapper.new.find(params[:id].to_i)
  end

  def update
    @customer = CustomerMapper.new.find(params[:id].to_i)

    @customer.forename = customer_params[:forename]
    @customer.surname = customer_params[:surname]

    CustomerMapper.new.update @customer

    redirect_to customers_path, notice: "Der Kunde wurde erfolgreich aktualisiert."
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
