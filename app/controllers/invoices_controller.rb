require "month"

class InvoicesController < ApplicationController
  before_filter :set_previous_and_next_month, only: [:index]

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

    def set_previous_and_next_month
      @previous_month = get_month.previous.first_day
      @next_month = get_month.next.first_day
    end
end
