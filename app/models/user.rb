require 'active_model'

class User
  extend ActiveModel::Naming
  extend ActiveModel::Translation
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :id, :name, :password, :password_confirmation, :password_digest

  def initialize(attributes={})
    attributes.each do |key, value|
      public_send "#{key}=", value
    end
  end

  def persisted?
    !id.nil?
  end

  def roles
    @roles ||= []
  end

  ## FIXME hack used in registration view
  def role
    roles.first
  end

  def add_role(role)
    roles << role
  end

  def set_role(role)
    @roles = [role]
  end

  def has_role?(role)
    roles.include? role
  end
end
