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
    request = OpenStruct.new(customer_id: params[:id].to_i, forename: customer_params[:forename], surname: customer_params[:surname], prefix: customer_params[:prefix])
    response = Interactor::UpdateCustomer.new(request).run
    @customer = response.object

    request = OpenStruct.new(customer_id: params[:id].to_i, street_name: address_params[:street_name], street_number: address_params[:street_number], postal_code: address_params[:postal_code], town: address_params[:town])
    Interactor::UpdateAddressForCustomer.new(request).run

    redirect_to customers_path, notice: "Der Kunde wurde erfolgreich aktualisiert."
  end

  def create
    request = OpenStruct.new(forename: customer_params[:forename], surname: customer_params[:surname], prefix: customer_params[:prefix])
    response = Interactor::CreateCustomer.new(request).run

    if response.success?
      request = OpenStruct.new(customer_id: response.object.id, street_name: address_params[:street_name], street_number: address_params[:street_number], postal_code: address_params[:postal_code], town: address_params[:town])
      Interactor::AddAddressToCustomer.new(request).run
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
      params.require(:customer).permit(:forename, :surname, :prefix)
    end

    def address_params
      params[:customer][:address]
    end
end
