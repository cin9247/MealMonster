class Api::V1::OrdersController < Api::V1::ApiController
  respond_to :json

  def create
    if valid_request? params
      request = OpenStruct.new(customer_id: params[:customer_id].to_i, offering_id: params[:offering_id], note: params[:note])
      @order = interact_with(:create_order, request).object

      respond_with @order, status: 201
    else
      render json: {errors: errors.map { |e| {message: e} }}, status: 400
    end
  end

  def deliver
    Interactor::Deliver.new(request_from_id).run.object
    head :no_content
  end

  def load
    Interactor::Load.new(request_from_id).run.object
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

    def request_from_id
      OpenStruct.new(order_id: params[:id])
    end

    def interact_with(use_case, request)
      interactor_class = Interactor.const_get use_case.to_s.camelize
      begin
        policy_class = Policy.const_get "#{use_case.to_s.camelize}Policy"
      rescue NameError

      end

      if policy_class.new(current_user).can? request
        interactor_class.new(request).run
      end
    end
end
