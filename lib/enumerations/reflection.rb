module Enumerations
  class Reflection
    attr_reader :name, :options

    def initialize(name, options = {})
      @name = name
      @options = options
    end

    def class_name
      @class_name ||= (options[:class_name] || name).to_s.camelize
    end

    def foreign_key
      @foreign_key ||= (options[:foreign_key] || default_foreign_key_name).to_sym
    end

    def enumerator_class
      @enumerator_class ||= class_name.constantize
    end

    private

    def default_foreign_key_name
      [name, Enumerations.configuration.foreign_key_suffix].compact.join('_')
    end
  end
end
