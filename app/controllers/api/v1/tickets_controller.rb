class Api::V1::TicketsController < Api::V1::ApiController
  respond_to :json

  def create
    request = OpenStruct.new(title: params[:title], body: params[:body], customer_id: params[:customer_id])
    @ticket = InteractorFactory.execute(:create_ticket, request, current_user).object
    respond_with(@ticket, status: 201)
  end
end
