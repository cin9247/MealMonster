class Api::V1::OrdersController < Api::V1::ApiController
  respond_to :json

  def create
    if valid_request? params
      interactor = Interactor::CreateOrder.new(params[:customer_id].to_i, params[:offering_id].to_i, params[:note])

      @order = interactor.run(12).object

      respond_with @order, status: 201
    else
      render json: {errors: errors.map { |e| {message: e} }}, status: 400
    end
  end

  def deliver
    Interactor::Deliver.new(params[:id]).run.object
    head :no_content
  end

  private
    def valid_request?(params)
      require_param :offering_id
      require_param :customer_id
      errors.blank?
    end

    def require_param(key)
      errors << "#{key} is missing" unless params.has_key?(key)
    end

    def errors
      @errors ||= []
    end
end
