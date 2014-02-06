require "delegate"

class CustomerPresenter < SimpleDelegator
  def street
    return "" unless address
    "#{address.street_name} #{address.street_number}"
  end

  def short_address
    return "" unless address
    "#{address.street_name} #{address.street_number}, #{address.town}"
  end

  def town
    return "" unless address
    address.town
  end

  def postal_code
    return "" unless address
    address.postal_code
  end

  def telephone_number
    return "(Keine)" unless __getobj__.telephone_number.present?
    __getobj__.telephone_number
  end

  def catchment_area_name
    return "(Keines)" unless catchment_area
    catchment_area.name
  end
end
