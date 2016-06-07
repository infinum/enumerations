module Enumeration
  class Reflection
    attr_reader :name

    def initialize(name, options)
      @name = name
      @options = options
    end

    def class_name
      @options[:class_name]
    end

    def foreign_key
      @options[:foreign_key]
    end
  end
end
