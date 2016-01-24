require 'active_support'
require 'active_support/concern'
require 'active_support/core_ext/class/attribute.rb'
require 'active_support/core_ext/string/inflections.rb'

require 'enumerations/version'
require 'enumerations/base'
require 'enumerations/reflection'

# TODO: rename to Enumeration(s) in a major version change
module Enumeration
  extend ActiveSupport::Concern

  included do
    class_attribute :_enumerations
    self._enumerations = []
  end

  module ClassMethods
    # Create an enumeration for the symbol <tt>name</tt>.
    # Options include <tt>foreign_key</tt> attribute and <tt>class_name</tt>
    #
    # Example:
    #
    #    enumeration :role
    #
    def enumeration(name, options = {})
      options[:foreign_key] ||= "#{name}_id".to_sym
      options[:class_name] ||= name.to_s.camelize

      add_enumeration(name, options)
    end

    # Output all the enumerations that this model has defined
    # Returns an array of Reflection objects for all the
    # enumerations in the class.
    #
    # Example:
    #
    #   User.reflect_on_all_enumerations  # returns an array of all enumerations
    #
    def reflect_on_all_enumerations
      _enumerations
    end

    private

    def add_enumeration(name, options)
      # Getter for belongs_to
      #
      # Example:
      #
      #   user.role => #<struct Role id=1, name="Admin", symbol=:admin>
      #
      define_method name do
        options[:class_name].constantize.find(send(options[:foreign_key]))
      end

      # Setter for belongs_to
      #
      # Example:
      #
      #   user.role = Role.admin => #user.role_id = 1
      #
      define_method "#{name}=" do |other|
        send("#{options[:foreign_key]}=", other.id)
      end

      self._enumerations += [Reflection.new(name, options)]
    end
  end
end

# Extend ActiveRecord with Enumeration capabilites
ActiveSupport.on_load(:active_record) do
  include Enumeration
end
