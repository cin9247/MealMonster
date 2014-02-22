class AllTimeOfferingsController < ApplicationController
  def new
    @price_classes = PriceClassMapper.new.fetch
    @offering = AllTimeOffering.new
  end

  def index
    @offerings = OfferingMapper.new.fetch_all_time_offerings
  end

  def create
    request = OpenStruct.new(name: params[:all_time_offering][:name], price_class_id: params[:all_time_offering][:price_class_id].to_i)
    interact_with :create_all_time_offering, request
    redirect_to all_time_offerings_path, notice: "Angebot erfolgreich erstellt."
  end
end
