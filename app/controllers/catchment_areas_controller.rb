class CatchmentAreasController < ApplicationController
  before_filter :fetch_catchment_area, only: [:show, :edit, :update]

  def index
    @catchment_areas = CatchmentAreaMapper.new.fetch
  end

  def new
    @catchment_area = CatchmentArea.new
  end

  def edit
  end

  def update
    @catchment_area.name = catchment_area_params[:name]
    CatchmentAreaMapper.new.update @catchment_area
    redirect_to catchment_areas_path, notice: "Einzugsgebiet erfolgreich aktualisiert."
  end

  def create
    catchment_area = CatchmentArea.new catchment_area_params
    CatchmentAreaMapper.new.save catchment_area
    redirect_to catchment_areas_path, notice: "Einzugsgebiet erfolgreich erstellt."
  end

  private
    def fetch_catchment_area
      @catchment_area = CatchmentAreaMapper.new.find params[:id].to_i
    end

    def catchment_area_params
      params.require(:catchment_area).permit(:name)
    end
end
