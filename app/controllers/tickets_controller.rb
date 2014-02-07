class TicketsController < ApplicationController
  def index
    ## TODO put in catchment area?
    @tickets = InteractorFactory.execute(:list_tickets, nil, current_user).object
  end

  def show
    @ticket = TicketMapper.new.find params[:id].to_i
  end

  def new
    @ticket = Ticket.new
    @customers = CustomerMapper.new.fetch
  end

  def create
    request = OpenStruct.new(title: ticket_params[:title], body: ticket_params[:body], customer_id: ticket_params[:customer_id])
    InteractorFactory.execute(:create_ticket, request, current_user).object
    redirect_to tickets_path
  end

  private
    def ticket_params
      params.require(:ticket).permit(:title, :body, :customer_id)
    end
end
