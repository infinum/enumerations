# i want to be able to write
# DogType < Enumeration
#   enumerate_values :pekinezer, :bulldog, :jack_russell
#
#   enumerate_values :pekinezer => 'Jako lijepi pekinezer'
# end
#
# DogType.all => [DogType, DogType, DogType]
# DogType.find(id) => DogType
# 
# if something == DogType.pekinezer # => <#DogType>
# if something == DogType::Pekinezer # => <#DogType> # => TODO
# if something == DogType[:pekinezer] # => <#DogType> # => TODO
#
# So we have
# * id (numeric). used in database
# * lookup method (for comparison), symbol basically, used in source code
# * name. used in user interface
#
# Status.draft?
# Status.review_pending?
#
# TODO 
# - http://github.com/binarylogic/enumlogic/blob/master/lib/enumlogic.rb
# - http://github.com/eeng/ar-enums
# - think about storing strings, not integers
module Enumeration
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
    end
  end
  
  class Base < Struct.new(:id, :name, :symbol)
    class_inheritable_accessor :all, :id_index, :symbol_index
    
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
      if self.class.find(symbol) && method_name.to_s.last=="?"
        self.symbol == symbol.to_sym
      else
        super(method_name, args)
      end
    end
  end
end
