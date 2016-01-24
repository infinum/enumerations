require 'active_support/core_ext/class/attribute'
require 'active_support/core_ext/string/inflections'
require 'enumerations/value'

module Enumeration
  class Base
    class_attribute :_values, :_symbol_index
    self._values = {}
    self._symbol_index = {}

    # Adding new value to enumeration
    #
    # Example:
    #
    #   value :admin, id: 1, name: 'Admin', description: 'Some description...'
    #
    #   Role.admin.id => # 1
    #   Role.find(:admin).name => # "Admin"
    #   Role.find(1).description => # "Some description..."
    #
    def self.value(symbol, attributes)
      # TODO: make this errors better if needed
      # TODO: test this errors
      fail 'Enumeration id is required' if attributes[:id].nil?
      fail "Duplicate symbol #{symbol}" if find(symbol)
      fail "Duplicate id #{attributes[:id]}" if find(attributes[:id])

      self._values = _values.merge(symbol => Enumeration::Value.new(self, symbol, attributes))
      self._symbol_index = _symbol_index.merge(symbol => id)

      # Adds name base finder methods
      #
      # Example:
      #
      #    Role.admin => #<Enumeration::Value:0x007fff45d7ec30 @base=Role, @symbol=:admin...>
      #    Role.staff => #<Enumeration::Value:0x007f980e9cb0a0 @base=Role, @symbol=:staff...>
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
    #   Role.all => # [#<Enumeration::Value:0x007f8ed7f46100 @base=Role, @symbol=:admin...>,
    #                  #<Enumeration::Value:0x007f8ed7f45de0 @base=Role, @symbol=:manager...>,
    #                  #<Enumeration::Value:0x007f8ed7f45ae8 @base=Role, @symbol=:staff...>]
    #
    def self.all
      _values.values
    end

    # Finds an enumeration by symbol, id or name
    #
    # Example:
    #
    #   Role.find(:admin)  => #<Enumeration::Value:0x007f8ed7f46100 @base=Role, @symbol=:admin...>
    #   Role.find(2)       => #<Enumeration::Value:0x007f8ed7f45de0 @base=Role, @symbol=:manager...>
    #   Role.find('2')     => #<Enumeration::Value:0x007f8ed7f45de0 @base=Role, @symbol=:manager...>
    #   Role.find('staff') => #<Enumeration::Value:0x007f8ed7f45ae8 @base=Role, @symbol=:staff...>
    #
    def self.find(key)
      case key
      when Symbol then find_by_key(key)
      when String then find_by_key(key.to_sym) || find_by_id(key.to_i)
      when Fixnum then find_by_id(key)
      end
    end

    def self.find_by_key(key)
      _values[key]
    end
    private_class_method :find_by_key

    def self.find_by_id(id)
      _values[_symbol_index.key(id)]
    end
    private_class_method :find_by_id
  end
end
