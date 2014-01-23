module Policy
  class AddAddressToCustomerPolicy
    attr_reader :user

    def initialize(user)
      @user = user
    end

    def can?(request)
      return true if user.has_role?(:admin) || user.has_role?(:user)
      false
    end
  end
end
