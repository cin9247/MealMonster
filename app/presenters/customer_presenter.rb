require "delegate"

class CustomerPresenter < SimpleDelegator
  def short_address
    return "" unless address
    "#{address.street_name} #{address.street_number}, #{address.town}"
  end
end
