require 'ostruct'

module Interactor
  class Base
    def self.register_boundary(name, default_proc)
      name = name.to_sym

      attr_writer name

      define_method(name) do
        instance_variable_set("@#{name}", instance_variable_get("@#{name}") || default_proc.call)
      end
    end
  end
end
