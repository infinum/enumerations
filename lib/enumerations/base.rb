require 'active_support/core_ext/class/attribute'
require 'active_support/core_ext/string/inflections'
require 'enumerations/value'
require 'enumerations/finder_methods'

module Enumerations
  class Base
    extend Enumerations::FinderMethods
    include Enumerations::Value

    class_attribute :_values, :_symbol_index

    self._values = {}
    self._symbol_index = {}

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

    def self.validate_symbol_and_primary_key(symbol, attributes)
      raise "Duplicate symbol #{symbol}" if find(symbol)

      primary_key = Enumerations.configuration.primary_key
      return if primary_key.nil?

      raise 'Enumeration primary key is required' if attributes[primary_key].nil?
      raise "Duplicate primary key #{attributes[primary_key]}" if find(attributes[primary_key])

      self._symbol_index = _symbol_index.merge(symbol => attributes[primary_key])
    end

    private_class_method :validate_symbol_and_primary_key

    attr_reader :symbol, :attributes

    def initialize(symbol, attributes)
      @symbol = symbol
      @attributes = attributes

      create_instance_methods
    end
  end
end
