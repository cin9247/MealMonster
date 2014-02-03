class PriceClassesController < ApplicationController
  before_filter :fetch_price_class, only: [:show, :update, :edit, :destroy]

  def index
    @price_classes = PriceClassMapper.new.fetch
  end

  def new
    @price_class = PriceClass.new
  end

  def edit
  end

  def create
    money = Money.parse price_class_params[:price]
    pc = PriceClass.new price: money, name: price_class_params[:name]
    PriceClassMapper.new.save pc
    redirect_to price_classes_path, notice: "Preisklasse erfolgreich erstellt."
  end

  def destroy
    PriceClassMapper.new.delete @price_class
    redirect_to price_classes_path, notice: "Preisklasse erfolgreich entfernt."
  end

  def update
    money = Money.parse price_class_params[:price]
    @price_class.price = money
    @price_class.name = price_class_params[:name]
    PriceClassMapper.new.update @price_class

    redirect_to price_classes_path, notice: "Preisklasse erfolgreich aktualisiert."
  end

  private
    def price_class_params
      params.require(:price_class).permit(:name, :price)
    end

    def fetch_price_class
      @price_class = PriceClassMapper.new.find params[:id].to_i
    end
end
