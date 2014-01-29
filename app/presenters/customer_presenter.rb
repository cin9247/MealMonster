require "delegate"

class CustomerPresenter < SimpleDelegator
  def short_address
    return "" unless address
    "#{address.street_name} #{address.street_number}, #{address.town}"
  end

  def catchment_area_name
    return "(Keines)" unless catchment_area
    catchment_area.name
  end
end
