class CustomersController < ApplicationController
  before_filter :fetch_catchment_areas, only: [:new, :edit]

  def index
    @customers = wrap CustomerMapper.new.fetch
  end

  def new
    @customer = Customer.new
  end

  def edit
    @customer = CustomerMapper.new.find(params[:id].to_i)
  end

  def update
    response = interact_with :update_customer, customer_request(params[:id].to_i)
    @customer = response.object

    interact_with :update_address_for_customer, address_request(params[:id].to_i)

    if customer_params[:catchment_area_id]
      interact_with :set_catchment_area_for_customer, catchment_area_request(@customer.id)
    else
      ## TODO remove catchment area from customer
    end

    redirect_to customers_path, notice: "Der Kunde wurde erfolgreich aktualisiert."
  end

  def create
    response = interact_with :create_customer, customer_request

    if response.success?
      customer = response.object

      interact_with :add_address_to_customer, address_request(customer.id)

      if customer_params[:catchment_area_id]
        interact_with :set_catchment_area_for_customer, catchment_area_request(customer.id)
      end

      redirect_to customers_path, notice: "Kunde erfolgreich erstellt."
    else
      @customer = response.object
      flash[:error] = "Es gab einen Fehler beim Erstellen des Kunden."
      render :new
    end
  end

  def show
    @customer = wrap CustomerMapper.new.find(params[:id].to_i)
  end

  private
    def customer_params
      params.require(:customer).permit(:forename, :surname, :prefix, :telephone_number, :catchment_area_id, :note, :date_of_birth, :email)
    end

    def address_params
      params[:customer][:address]
    end

    def customer_request(customer_id=nil)
      date_of_birth = parse_date customer_params[:date_of_birth]

      OpenStruct.new(customer_id: customer_id, forename: customer_params[:forename], surname: customer_params[:surname], prefix: customer_params[:prefix], telephone_number: customer_params[:telephone_number], note: customer_params[:note], date_of_birth: date_of_birth, email: customer_params[:email])
    end

    def address_request(customer_id)
      OpenStruct.new(customer_id: customer_id, street_name: address_params[:street_name], street_number: address_params[:street_number], postal_code: address_params[:postal_code], town: address_params[:town])
    end

    def catchment_area_request(customer_id)
      OpenStruct.new(customer_id: customer_id, catchment_area_id: customer_params[:catchment_area_id])
    end

    def fetch_catchment_areas
      @catchment_areas = CatchmentAreaMapper.new.fetch
    end

    def parse_date date_as_string
      Date.parse date_as_string
    rescue ArgumentError
      return nil
    end
end
