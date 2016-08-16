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
    #  user.role => #<Enumeration::Value: @base=Role, @symbol=:admin...>
    #
    #  user.role = Role.staff
    #  user.role_id => 2
    #
    def enumeration(name, options = {})
      reflection = Reflection.new(name, options)

      add_enumeration(reflection)
    end

    # Output all the enumerations that this model has defined
    # Returns an array of Reflection objects for all the
    # enumerations in the class.
    #
    # Example:
    #
    #   User.reflect_on_all_enumerations => # [
    #      #<Enumeration::Reflection: @name=:role...>,
    #      #<Enumeration::Reflection: @name=:status...>
    #   ]
    #
    def reflect_on_all_enumerations
      _enumerations
    end

    private

    def add_enumeration(reflection)
      define_getter_method(reflection)
      define_setter_method(reflection)
      define_bang_methods(reflection)
      define_scopes(reflection)

      self._enumerations += [reflection]
    end

    # Getter for belongs_to
    #
    # Example:
    #
    #   user.role_id = 1
    #   user.role => #<Enumeration::Value: @base=Role, @symbol=:admin...>
    #
    def define_getter_method(reflection)
      define_method(reflection.name) do
        reflection.enumerator_class.find(send(reflection.foreign_key))
      end
    end

    # Setter for belongs_to
    #
    # Example:
    #
    #   user.role = Role.admin
    #   user.role_id => 1
    #
    def define_setter_method(reflection)
      define_method("#{reflection.name}=") do |other|
        send("#{reflection.foreign_key}=", other.id)
      end
    end

    # Add bang methods for setting all enumeration values.
    # All methods are prefixed with enumeration name.
    #
    # Example:
    #
    #   user.role_admin!
    #   user.role => #<Enumeration::Value: @base=Role, @symbol=:admin...>
    #
    def define_bang_methods(reflection)
      reflection.enumerator_class.all.each do |enumeration|
        define_method("#{reflection.name}_#{enumeration.to_sym}!") do
          send("#{reflection.name}=", enumeration)
        end
      end
    end

    # Scopes for enumerated ActiveRecord model.
    # Format of scope name is with_#{enumeration_name}_#{enumeration_value_name}.
    #
    # Example:
    #
    #   User.with_role_admin => <#ActiveRecord::Relation []>
    #   User.with_role_editor => <#ActiveRecord::Relation []>
    #
    def define_scopes(reflection)
      reflection.enumerator_class.all.each do |enumeration|
        scope "with_#{reflection.name}_#{enumeration.symbol}",
              -> { where(reflection.foreign_key => enumeration.id) }
      end
    end
  end
end

# Extend ActiveRecord with Enumeration capabilites
ActiveSupport.on_load(:active_record) do
  include Enumeration
end
