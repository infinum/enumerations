require 'active_support'
require 'active_support/concern'
require 'active_support/core_ext/class/attribute'
require 'active_support/core_ext/string/inflections'

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
    #   class User < ActiveRecord::Base
    #     enumeration :role
    #   end
    #
    #  user.role_id = 1
    #  user.role => #<Enumeration::Value:0x007fff45d7ec30 @base=Role, @symbol=:admin...>
    #
    #  user.role = Role.staff
    #  user.role_id => 2
    #
    # TODO: add documentation for foreign_key and class_name
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
    #   User.reflect_on_all_enumerations => # [
    #      #<Enumeration::Reflection:0x007fe894724320 @name=:role...>,
    #      #<Enumeration::Reflection:0x007fe89471d020 @name=:status...>]
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
      #   user.role_id = 1
      #   user.role => #<Enumeration::Value:0x007fff45d7ec30 @base=Role, @symbol=:admin...>
      #
      define_method name do
        options[:class_name].constantize.find(send(options[:foreign_key]))
      end

      # Setter for belongs_to
      #
      # Example:
      #
      #   user.role = Role.admin
      #   user.role_id => 1
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
