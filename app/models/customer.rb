require 'active_model'

class Customer
  extend ActiveModel::Naming
  extend ActiveModel::Translation
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :id, :organization, :telephone_number, :prefix, :forename, :surname, :address, :catchment_area, :note, :date_of_birth, :email, :created_at, :updated_at

  def initialize(attributes={})
    attributes.each do |key, value|
      public_send "#{key}=", value
    end
  end

  def full_name
    "#{forename} #{surname}"
  end

  def full_name_reversed
    "#{surname}, #{forename}"
  end

  def persisted?
    !id.nil?
  end

  def catchment_area_id
    catchment_area && catchment_area.id
  end
end
