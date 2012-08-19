require 'active_support/core_ext/class/attribute.rb'
require 'active_support/core_ext/string/inflections.rb'

module Enumeration
  VERSION = "1.1"
  
  def self.included(receiver)
    receiver.extend ClassMethods
  end
  
  module ClassMethods
    # create an enumeration for the symbol <tt>name</tt>. Options include <tt>foreign key</tt> attribute and Class name
    def enumeration(name, options = {})
      options[:foreign_key] ||= "#{name}_id".to_sym
      options[:class_name] ||= name.to_s.camelize
      
      # getter for belongs_to
      define_method name do
        options[:class_name].constantize.find(send(options[:foreign_key]))
      end
      
      # setter for belongs_to 
      define_method "#{name}=" do |other|
        send("#{options[:foreign_key]}=", other.id)
      end
      
      # store a list of used enumerations
      @_all_enumerations ||= []
      @_all_enumerations << EnumerationReflection.new(name, options)            
    end

    # output all the enumerations that this model has defined
    def reflect_on_all_enumerations
      @_all_enumerations
    end
  end
  
  class EnumerationReflection < Struct.new(:name, :options)
    def class_name
      options[:class_name]
    end
    
    def foreign_key
      options[:foreign_key]
    end
  end  
  
  # used as a base class for enumeration classes
  class Base < Struct.new(:id, :name, :symbol)
    class_attribute :all, :id_index, :symbol_index
    
    def singleton_class
      class << self
        self
      end
    end    
    
    def self.values(values)
      # all values
      self.all = []
      # for id based lookup
      self.id_index = {}
      # for symbol based lookup
      self.symbol_index = {}
      
      values.each_pair do |symbol, attributes|
        attributes[:name] ||= symbol.to_s.humanize
        object = self.new(attributes[:id], attributes[:name], symbol)

        self.singleton_class.send(:define_method, symbol) do
          object
        end
        
        raise "Duplicate id #{attributes[:id]}" if self.id_index[attributes[:id]]
        raise "Duplicate symbol #{symbol}" if self.symbol_index[symbol]        
        
        self.id_index[attributes[:id]] = object
        self.symbol_index[symbol] = object
        self.all << object
      end
    end
    
    # lookup a specific enum
    def self.find(id)
      if id.is_a?(Fixnum)
        self.id_index[id]
      elsif id.is_a?(Symbol) || id.is_a?(String)
        self.symbol_index[id.to_sym]
      end
    end
    
    # FIXME for some reason this doesn't work for case..when expressions
    def ==(object)  
      if object.is_a?(Fixnum)
        object == self.id
      elsif object.is_a?(Symbol)
        object == self.symbol
      elsif object.is_a?(self.class)
        object.id == self.id
      end
    end
    
    # TODO alias method??
    def to_s
      name
    end  
    
    def to_i
      id
    end
    
    def to_sym
      symbol 
    end
    
    def to_param
      id  
    end
    
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