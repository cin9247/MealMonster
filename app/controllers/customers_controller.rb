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
    response = Interactor::UpdateCustomer.new(params[:id].to_i, customer_params[:forename], customer_params[:surname]).run
    @customer = response.object

    @customer.address = Address.new unless @customer.address

    @customer.address.town = params[:customer][:address][:town]
    @customer.address.street_name = params[:customer][:address][:street_name]
    @customer.address.street_number = params[:customer][:address][:street_number]
    @customer.address.postal_code = params[:customer][:address][:postal_code]

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
