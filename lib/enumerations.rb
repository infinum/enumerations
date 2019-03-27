require 'active_support'
require 'active_support/concern'
require 'active_support/core_ext/class/attribute'
require 'active_support/core_ext/string/inflections'

require 'enumerations/configuration'
require 'enumerations/version'
require 'enumerations/base'
require 'enumerations/reflection'
require 'enumerations/errors'

module Enumerations
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
    #  user.role => #<Enumerations::Value: @base=Role, @symbol=:admin...>
    #
    #  user.role = Role.staff
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
    #      #<Enumerations::Reflection: @name=:role...>,
    #      #<Enumerations::Reflection: @name=:status...>
    #   ]
    #
    def reflect_on_all_enumerations
      _enumerations
    end

    def fetch_foreign_key_values(reflection, *symbols)
      symbols.flatten.map do |symbol|
        enumeration_value = reflection.enumerator_class.find(symbol)

        enumeration_value &&
          enumeration_value.send(reflection.enumerator_class.primary_key || :symbol)
      end
    end

    private

    def add_enumeration(reflection)
      define_getter_method(reflection)
      define_setter_method(reflection)
      define_bang_methods(reflection)
      define_scopes_for_each_enumeration_value(reflection)
      define_enumeration_scope(reflection)

      self._enumerations += [reflection]
    end

    # Getter for belongs_to
    #
    # Example:
    #
    #   user.role = Role.admin
    #   user.role => #<Enumerations::Value: @base=Role, @symbol=:admin...>
    #
    def define_getter_method(reflection)
      define_method(reflection.name) do
        reflection.enumerator_class.find(self[reflection.foreign_key])
      end
    end

    # Setter for belongs_to
    #
    # Example:
    #
    #   user.role = Role.admin
    #
    def define_setter_method(reflection)
      define_method("#{reflection.name}=") do |other|
        enumeration_value = reflection.enumerator_class.find(other)

        raise Enumerations::InvalidValueError if other.present? && enumeration_value.nil?

        self[reflection.foreign_key] =
          enumeration_value &&
          enumeration_value.send(reflection.enumerator_class.primary_key || :symbol)
      end
    end

    # Add bang methods for setting all enumeration values.
    # All methods are prefixed with enumeration name.
    #
    # Example:
    #
    #   user.role_admin!
    #   user.role => #<Enumerations::Value: @base=Role, @symbol=:admin...>
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
    def define_scopes_for_each_enumeration_value(reflection)
      reflection.enumerator_class.all.each do |enumeration|
        foreign_key = enumeration.send(reflection.enumerator_class.primary_key || :symbol)

        scope("with_#{reflection.name}_#{enumeration.symbol}",
              -> { where(reflection.foreign_key => foreign_key) })

        scope("without_#{reflection.name}_#{enumeration.symbol}",
              -> { where.not(reflection.foreign_key => foreign_key) })
      end
    end

    # Scope for enumerated ActiveRecord model.
    # Format of scope name is with_#{enumeration_name}(*enumerations).
    #
    # Example:
    #
    #   User.with_role(:admin) => <#ActiveRecord::Relation []>
    #   User.with_role(:admin, Role.editor) => <#ActiveRecord::Relation []>
    #
    def define_enumeration_scope(reflection)
      scope("with_#{reflection.name}",
            lambda do |*symbols|
              where(reflection.foreign_key => fetch_foreign_key_values(reflection, symbols))
            end)

      scope("without_#{reflection.name}",
            lambda do |*symbols|
              where.not(reflection.foreign_key => fetch_foreign_key_values(reflection, symbols))
            end)
    end
  end
end

# Extend ActiveRecord with Enumeration capabilites
ActiveSupport.on_load(:active_record) do
  include Enumerations
end
