# required for class_attribute method
require 'active_support/core_ext/class/attribute.rb'

module Enumeration
  # Used as a Base class for enumeration classes
  Base = Struct.new(:id, :name, :symbol) do
    class_attribute :all, :id_index, :symbol_index, :attribute_list

    def singleton_class
      class << self
        self
      end
    end

    # All values
    self.all = []
    # For id based lookup
    self.id_index = {}
    # For symbol based lookup
    self.symbol_index = {}
    # Methods on enum
    self.attribute_list = [:id, :name]

    def self.values(values)
      values.each_pair do |symbol, attributes|
        value(symbol, attributes)
      end
    end

    def self.value(symbol, attributes)
      attributes[:name] ||= symbol.to_s.humanize

      object = new(attributes[:id], attributes[:name], symbol)

      singleton_class.send(:define_method, symbol) do
        object
      end

      fail "Duplicate id #{attributes[:id]}" if id_index[attributes[:id]]
      fail "Duplicate symbol #{symbol}" if symbol_index[symbol]

      id_index[attributes[:id]] = object
      symbol_index[symbol] = object
      all << object

      update_enum_methods(object, attributes)
    end

    def self.update_enum_methods(object, attributes)
      self.attribute_list |= attributes.keys

      attribute_list.each do |method|
        all.each do |enum|
          next if enum.respond_to?(method)

          enum.singleton_class.class_eval do
            define_method(method) { attributes[method] if enum.id == object.id }
          end
        end
      end
    end

    private_class_method :update_enum_methods

    # Lookup a specific enum
    def self.find(id)
      case id
      when Fixnum
        id_index[id]
      when Symbol, String
        symbol_index[id.to_sym]
      end
    end

    def ==(other)
      case other
      when Fixnum
        other == id
      when Symbol
        other == symbol
      when self.class
        other.id == id
      end
    end

    alias_method :to_s, :name
    alias_method :to_i, :id
    alias_method :to_sym, :symbol
    alias_method :to_param, :id

    def method_missing(method_name, *args)
      symbol = method_name.to_s.gsub(/[?]$/, '')
      if self.class.find(symbol) && method_name =~ /[?]$/
        self.symbol == symbol.to_sym
      else
        super(method_name, args)
      end
    end
  end
end
