require 'active_support/core_ext/class/attribute.rb'
require 'active_support/core_ext/string/inflections.rb'

require 'enumerations/version'

module Enumeration
  def self.included(receiver)
    receiver.extend ClassMethods
  end

  module ClassMethods
    # Create an enumeration for the symbol <tt>name</tt>.
    # Options include <tt>foreign key</tt> attribute and Class name
    def enumeration(name, options = {})
      options[:foreign_key] ||= "#{name}_id".to_sym
      options[:class_name] ||= name.to_s.camelize

      # Getter for belongs_to
      define_method name do
        options[:class_name].constantize.find(send(options[:foreign_key]))
      end

      # Setter for belongs_to
      define_method "#{name}=" do |other|
        send("#{options[:foreign_key]}=", other.id)
      end

      # Store a list of used enumerations
      @_all_enumerations ||= []
      @_all_enumerations << EnumerationReflection.new(name, options)
    end

    # Output all the enumerations that this model has defined
    def reflect_on_all_enumerations
      @_all_enumerations
    end
  end

  EnumerationReflection = Struct.new(:name, :options) do
    def class_name
      options[:class_name]
    end

    def foreign_key
      options[:foreign_key]
    end
  end

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

# Extend ActiveRecord with Enumeration capabilites
ActiveRecord::Base.send(:include, Enumeration) if defined? ActiveRecord
