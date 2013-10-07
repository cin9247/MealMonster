class CustomersController < ApplicationController
  def index
    @customers = organization.customers
  end
end
