require 'active_model'

class Meal
  extend ActiveModel::Naming
  extend ActiveModel::Translation
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :id, :name, :kitchen, :bread_units, :kilojoules, :created_at, :updated_at

  def initialize(attributes = {})
    self.attributes = attributes
  end

  def attributes=(attributes)
    attributes.each do |key, value|
      public_send "#{key}=", value
    end
  end

  def kilojoules=(kj)
    if kj.blank?
      @kilojoules = nil
    else
      @kilojoules = kj.to_i
    end
  end

  def bread_units=(bu)
    if bu.blank?
      @bread_units = nil
    else
      @bread_units = bu.to_f
    end
  end

  def persisted?
    !id.nil?
  end
end
