class InteractorFactory
  def self.execute(use_case, request, user)
    if Ability.new(user).can? use_case, request
      begin
        Interactor.const_get(use_case.camelize).new(request).run
      rescue NameError
        raise "There's no use case called #{use_case}."
      end
    end
  end
end

# class Policy
#   attr_reader :request
#   def initialize(request)
#     @request = request
#   end

#   def can?(user)
#     return true if user.has_role? :admin
#   end
# end

class CreateOrderPolicy
  register_boundary :order_gateway,    -> { OrderMapper.new }
  register_boundary :customer_gateway, -> { CustomerMapper.new }
  register_boundary :offering_gateway, -> { OfferingMapper.new }

  def initialize(request)
    @request = request
  end

  def can?(user)
    return true if user.admin?
    if user.has_role? :customer
      user.customer.id == @request.customer_id
    else
      false
    end
  end
end

class ListToursPolicy
  def can?(user)
    return true if user.admin?
    return true if user.has_role? :user
    false
  end
end

ListTours ## request = {user_id, date}

class ListTourByDriverPolicy
  def can?(user)
    return true if user.admin?

    return @request.driver_id == user.id if user.has_role? :driver

    false
  end
end

class ListStationsPolicy
  register_boundary :tour_gateway,  -> { TourMapper.new }

  def can?(user)
    return true if user.admin?

    if user.has_role? :driver
      tour = tour_gateway.find @request.tour_id
      tour.driver.id == user.id
    end
  end
end


if ListStationsPolicy.new(32, date).can?(current_user)
  ListStations.new(32).run
else
  raise Interactor::NotAuthorized
end
