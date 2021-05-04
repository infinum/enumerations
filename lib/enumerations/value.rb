module Enumerations
  module Value
    def to_i
      _values.keys.index(symbol) + 1
    end

    def to_s
      symbol.to_s
    end

    def to_param
      to_s
    end

    def to_sym
      symbol
    end

    # Comparison by symbol or object
    #
    # Example:
    #
    #   Role.admin == :admin      => true
    #   Role.admin == Role.admin  => true
    #   Role.admin == :staff      => false
    #   Role.admin == Role.staff  => false
    #
    # TODO: test if case..when is working with this
    def ==(other)
      case other
      when String then other == to_s
      when Symbol then other == symbol
      else super
      end
    end

    private

    def create_instance_methods
      define_attributes_getters
      define_value_checking_method
      define_predicate_methods_for_attributes
    end

    # Getters for all attributes
    #
    # Example:
    #
    #   Role.admin => #<Enumerations::Value:0x007fff45d7ec30 @base=Role, @symbol=:admin,
    #                   @attributes={:id=>1, :name=>"Admin", :description=>"Some description..."}>
    #   user.role.id          => # 1
    #   user.role.name        => # "Admin"
    #   user.role.description => # "Some description..."
    #
    def define_attributes_getters
      @attributes.each do |key, _|
        next if self.class.instance_methods(false).include?(key)

        self.class.send :define_method, key do |locale: I18n.locale|
          case @attributes[key]
          when String, Symbol then translate_attribute(key, locale)
          else @attributes[key]
          end
        end
      end
    end

    def translate_attribute(key, locale)
      return @attributes[key].to_s unless Enumerations.configuration.translate_attributes

      I18n.t(key, scope: [:enumerations, self.class.name.demodulize.underscore, symbol],
                  default: @attributes[key].to_s,
                  locale: locale)
    end

    # Predicate methods for values
    #
    # Example:
    #
    #   user.role = Role.admin
    #   user.role.admin? => # true
    #   user.role.staff? => # false
    #
    def define_value_checking_method
      self.class.send :define_method, "#{symbol}?" do
        __callee__[0..-2].to_sym == symbol
      end
    end

    # Predicate methods for all attributes
    #
    # Example:
    #
    #   class Role < Enumerations::Base
    #     value :admin, name: 'Administrator', active: false
    #   end
    #
    #   user.role.name?       => # true
    #   user.role.admin?      => # false
    #
    def define_predicate_methods_for_attributes
      @attributes.each do |key, _|
        method_name = "#{key}?"

        next if self.class.instance_methods(false).include?(method_name.to_sym)

        self.class.send :define_method, method_name do
          @attributes[key].present?
        end
      end
    end
  end
end
