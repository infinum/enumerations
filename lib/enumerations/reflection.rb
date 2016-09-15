module Enumerations
  class Reflection
    attr_reader :name

    def initialize(name, options = {})
      @name = name
      @options = options
    end

    def class_name
      @class_name ||= (@options[:class_name] || name).to_s.camelize
    end

    def foreign_key
      @foreign_key ||= (@options[:foreign_key] || name).to_sym
    end

    def enumerator_class
      @enumerator_class ||= class_name.constantize
    end
  end
end
