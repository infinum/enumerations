module Enumerations
  module FinderMethods
    # Finds an enumeration by symbol or name
    #
    # Example:
    #
    #   Role.find(:admin)  => #<Enumerations::Value: @base=Role, @symbol=:admin...>
    #   Role.find('staff') => #<Enumerations::Value: @base=Role, @symbol=:staff...>
    #
    def find(key)
      case key
      when Symbol, String, Enumerations::Base then find_by_key(key.to_sym)
      end || find_by_primary_key(key)
    end

    # Finds all enumerations which meets given attributes.
    # Similar to ActiveRecord::QueryMethods#where.
    #
    # Example:
    #
    #   Role.find_by(name: 'Admin') => #<Enumerations::Value: @base=Role, @symbol=:admin...>
    #
    def where(**args)
      _values.values.select { |value| args.map { |k, v| value.attributes[k] == v }.all? }
    end

    # Finds an enumeration by defined attribute. Similar to ActiveRecord::FinderMethods#find_by
    #
    # Example:
    #
    #   Role.find_by(name: 'Admin') => #<Enumerations::Value: @base=Role, @symbol=:admin...>
    #
    def find_by(**args)
      where(**args).first
    end

    def find_by_key(key)
      _values[key]
    end

    def find_by_primary_key(primary_key)
      return value_from_symbol_index(primary_key.to_i) if primary_key.is_a?(String)

      value_from_symbol_index(primary_key)
    end

    private

    def value_from_symbol_index(key)
      _values[_symbol_index.key(key)]
    end
  end
end
