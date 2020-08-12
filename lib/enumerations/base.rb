require 'active_support/core_ext/class/attribute'
require 'active_support/core_ext/string/inflections'

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
      raise 'Enumeration id is required' if attributes[:id].nil?
      raise "Duplicate symbol #{symbol}" if find(symbol)
      raise "Duplicate id #{attributes[:id]}" if find(attributes[:id])

      self._values = _values.merge(symbol => new(symbol, attributes))
      self._symbol_index = _symbol_index.merge(symbol => attributes[:id])

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
      when Integer then find_by_id(key)
      end
    end

    # Finds an enumeration by defined attribute. Simmilar to AcriveRecord::FinderMethods#find_by
    #
    # Example:
    #
    #   Role.find_by(name: 'Admin')  => #<Enumeration::Value:0x007f8ed7f46100 @base=Role, @symbol=:admin...>
    #
    def self.find_by(**args)
      _values.values.find { |value| args.map { |k, v| value.send(k) == v }.all? }
    end

    def self.find_by_key(key)
      _values[key]
    end

    def self.find_by_id(id)
      _values[_symbol_index.key(id)]
    end

    def initialize(symbol, attributes)
      @symbol = symbol
      @attributes = attributes
      create_instance_methods
    end

    attr_reader :symbol

    def to_i
      id
    end

    def to_s
      name
    end

    def to_sym
      @symbol
    end

    def to_param
      id
    end

    # Comparison by id, symbol or object
    #
    # Example:
    #
    #   Role.admin == 1           => true
    #   Role.admin == :admin      => true
    #   Role.admin == Role.admin  => true
    #   Role.admin == 2           => false
    #   Role.admin == :staff      => false
    #   Role.admin == Role.staff  => false
    #
    # TODO: test if case..when is working with this
    def ==(other)
      case other
      when Integer then other == id
      when Symbol then other == @symbol
      else super
      end
    end

    private

    # Getters for all attributes
    #
    # Example:
    #
    #   Role.admin => #<Enumeration::Value:0x007fff45d7ec30 @base=Role, @symbol=:admin,
    #                   @attributes={:id=>1, :name=>"Admin", :description=>"Some description..."}>
    #   user.role.id => # 1
    #   user.role.name => # "Admin"
    #   user.role.description => # "Some description..."
    #   user.role.admin? => # true
    #   user.role.staff? => # false
    #
    def create_instance_methods
      @attributes.each do |key, _|
        self.class.send :define_method, key do
          @attributes[key]
        end
      end

      self.class.send :define_method, "#{@symbol}?" do
        __callee__[0..-2].to_sym == @symbol
      end
    end
  end
end
