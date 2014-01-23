class Link
  extend ActiveModel::Naming
  include ActiveModel::Conversion

  attr_accessor :user

  def initialize(user)
    @user = user
  end

  def customer_id
    if customer
     customer.id
    else
      nil
    end
  end

  def customer
    user.customer
  end

  def persisted?
    false
  end
end
