class AllTimeOfferingsController < ApplicationController
  before_filter :fetch_price_classes, only: [:new, :edit]

  def new
    @offering = AllTimeOffering.new
  end

  def index
    @offerings = OfferingMapper.new.fetch_all_time_offerings
  end

  def edit
    @offering = OfferingMapper.new.find params[:id].to_i
  end

  def update
    request = OpenStruct.new(name: params[:all_time_offering][:name], price_class_id: params[:all_time_offering][:price_class_id].to_i, offering_id: params[:id].to_i)
    interact_with :update_all_time_offering, request
    redirect_to all_time_offerings_path, notice: "Angebot erfolgreich erstellt."
  end

  def create
    request = OpenStruct.new(name: params[:all_time_offering][:name], price_class_id: params[:all_time_offering][:price_class_id].to_i)
    interact_with :create_all_time_offering, request
    redirect_to all_time_offerings_path, notice: "Angebot erfolgreich erstellt."
  end

  private
    def fetch_price_classes
      @price_classes = PriceClassMapper.new.fetch
    end
end
