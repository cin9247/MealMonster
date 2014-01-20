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
    response = interact_with :update_customer, customer_request(params[:id].to_i)
    @customer = response.object

    interact_with :update_address_for_customer, address_request(params[:id].to_i)

    redirect_to customers_path, notice: "Der Kunde wurde erfolgreich aktualisiert."
  end

  def create
    response = interact_with :create_customer, customer_request

    if response.success?
      request = address_request response.object.id
      interact_with :add_address_to_customer, request

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
