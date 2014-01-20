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
    response = Interactor::UpdateCustomer.new(customer_request(params[:id].to_i)).run
    @customer = response.object

    request = address_request params[:id].to_i
    Interactor::UpdateAddressForCustomer.new(request).run

    redirect_to customers_path, notice: "Der Kunde wurde erfolgreich aktualisiert."
  end

  def create
    response = Interactor::CreateCustomer.new(customer_request).run

    if response.success?
      request = address_request response.object.id
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

    def customer_request(customer_id=nil)
      OpenStruct.new(customer_id: customer_id, forename: customer_params[:forename], surname: customer_params[:surname], prefix: customer_params[:prefix])
    end

    def address_request(customer_id)
      OpenStruct.new(customer_id: customer_id, street_name: address_params[:street_name], street_number: address_params[:street_number], postal_code: address_params[:postal_code], town: address_params[:town])
    end
end
