require "month"

class InvoicesController < ApplicationController
  def index
    @customer = CustomerMapper.new.find params[:customer_id].to_i
    @invoice = interact_with(:create_invoice, OpenStruct.new(customer_id: params[:customer_id].to_i, month: get_month)).object
  end

  private
    def get_month
      if params[:month]
        date = Date.parse(params[:month])
      else
        date = Date.today
      end
      Month.from_date(date)
    end
end
