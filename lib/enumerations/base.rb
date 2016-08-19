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
    #   Role.admin.id             => # 1
    #   Role.find(:admin).name    => # "Admin"
    #   Role.find(1).description  => # "Some description..."
    #
    def self.value(symbol, attributes)
      raise 'Enumeration id is required' if attributes[:id].nil?
      raise "Duplicate symbol #{symbol}" if find(symbol)
      raise "Duplicate id #{attributes[:id]}" if find(attributes[:id])

      self._values = _values.merge(symbol => new(symbol, attributes))
      self._symbol_index = _symbol_index.merge(symbol => attributes[:id])

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
    #   Role.admin.id => # 1
    #   Role.find(:manager).name => # "Manager"
    #   Role.find(3).description => # "Some description..."
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

    attr_reader :symbol, :attributes

    def initialize(symbol, attributes)
      @symbol = symbol
      @attributes = attributes

      create_instance_methods
    end
  end
end
