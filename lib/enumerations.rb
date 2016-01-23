require 'active_support/core_ext/class/attribute.rb'
require 'active_support/core_ext/string/inflections.rb'

require 'enumerations/version'
require 'enumerations/base'

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
end

# Extend ActiveRecord with Enumeration capabilites
ActiveRecord::Base.send(:include, Enumeration) if defined? ActiveRecord
