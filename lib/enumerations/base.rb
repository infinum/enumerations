require 'active_support/core_ext/class/attribute'
require 'active_support/core_ext/string/inflections'
require 'enumerations/value'
require 'enumerations/finder_methods'

module Enumerations
  class Base < ActiveSupport::Multibyte::Chars
    extend Enumerations::FinderMethods
    include Enumerations::Value

    class_attribute :_values, :_symbol_index, :_primary_key, :_foreign_key_suffix

    self._values = {}
    self._symbol_index = {}
    self._primary_key = nil
    self._foreign_key_suffix = nil

    # Adding new value to enumeration
    #
    # Example:
    #
    #   value :admin, id: 1, name: 'Admin', description: 'Some description...'
    #
    #   Role.find(:admin).name          => # "Admin"
    #   Role.find(:admin).description   => # "Some description..."
    #
    def self.value(symbol, attributes = {})
      validate_symbol_and_primary_key(symbol, attributes)

      self._values = _values.merge(symbol => new(symbol, attributes))

      # Adds name base finder methods
      #
      # Example:
      #
      #    Role.admin => #<Enumerations::Value: @base=Role, @symbol=:admin...>
      #    Role.staff => #<Enumerations::Value: @base=Role, @symbol=:staff...>
      #
      singleton_class.send(:define_method, symbol) do
        find(symbol)
      end
    end

    # Adding multiple values to enumeration
    #
    # Example:
    #
    #   values admin:           { id: 1, name: 'Admin' },
    #          manager:         { id: 2, name: 'Manager' },
    #          staff:           { id: 3, name: 'Staff', description: 'Some description...' }
    #
    #   Role.admin.id                     => # 1
    #   Role.find(:manager).name          => # "Manager"
    #   Role.find(:manager).description   => # "Some description..."
    #
    def self.values(values)
      values.each do |symbol, attributes|
        value(symbol, attributes)
      end
    end

    # Returns an array of all enumeration symbols
    #
    # Example:
    #
    #   Role.symbols => # [:admin, :manager, :staff]
    #
    def self.symbols
      _values.keys
    end

    # Returns an array of all enumeration values
    #
    # Example:
    #
    #   Role.all => # [#<Enumerations::Value: @base=Role, @symbol=:admin...>,
    #                  #<Enumerations::Value: @base=Role, @symbol=:manager...>,
    #                  #<Enumerations::Value: @base=Role, @symbol=:staff...>]
    #
    def self.all
      _values.values
    end

    # Sets primary key for enumeration class.
    #
    # Example:
    #
    #   class Status < Enumeration::Base
    #     primary_key = :id
    #   end
    #
    def self.primary_key=(key)
      self._primary_key = key && key.to_sym
    end

    # Gets primary key for enumeration class.
    #
    # Example:
    #
    #   Status.primary_key  => # nil
    #
    #   class Status < Enumeration::Base
    #     primary_key = :id
    #   end
    #
    #   Status.primary_key  => # :id
    #
    def self.primary_key
      _primary_key || Enumerations.configuration.primary_key
    end

    # Sets foreign key suffix for enumeration class.
    #
    # Example:
    #
    #   class Status < Enumeration::Base
    #     foreign_key_suffix = :id
    #   end

    def self.foreign_key_suffix=(suffix)
      self._foreign_key_suffix = suffix && suffix.to_sym
    end

    # Gets foreign key suffix for enumeration class.
    #
    # Example:
    #
    #   Status.foreign_key_suffix  => # nil
    #
    #   class Status < Enumeration::Base
    #     foreign_key_suffix = :id
    #   end
    #
    #   Status.foreign_key_suffix  => # :id
    #
    def self.foreign_key_suffix
      _foreign_key_suffix || Enumerations.configuration.foreign_key_suffix
    end

    def self.validate_symbol_and_primary_key(symbol, attributes)
      raise Enumerations::DuplicatedSymbolError if find(symbol)

      return if primary_key.nil?

      primary_key_value = attributes[primary_key]

      raise Enumerations::MissingPrimaryKeyError if primary_key_value.nil?
      raise Enumerations::DuplicatedPrimaryKeyError if find(primary_key_value)

      self._symbol_index = _symbol_index.merge(symbol => primary_key_value)
    end

    private_class_method :validate_symbol_and_primary_key

    attr_reader :symbol, :attributes

    def initialize(symbol, attributes)
      super(symbol.to_s)

      @symbol = symbol
      @attributes = attributes

      create_instance_methods
    end

    private

    def chars(string)
      string
    end
  end
end
