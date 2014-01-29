module Policy
  # customer_id
  # offering_id
  # note
  class CreateOrderPolicy
    attr_reader :user

    def initialize(user)
      @user = user
    end

    def can?(request)
      return true if user.has_role?(:admin) || user.has_role?(:manager)

      if user.has_role? :customer
        return user.customer.id == request.customer_id
      end
    end
  end
end
