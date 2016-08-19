module Enumerations
  module FinderMethods
    # Finds an enumeration by symbol, id or name
    #
    # Example:
    #
    #   Role.find(:admin)  => #<Enumerations::Value: @base=Role, @symbol=:admin...>
    #   Role.find(2)       => #<Enumerations::Value: @base=Role, @symbol=:manager...>
    #   Role.find('2')     => #<Enumerations::Value: @base=Role, @symbol=:manager...>
    #   Role.find('staff') => #<Enumerations::Value: @base=Role, @symbol=:staff...>
    #
    def find(key)
      case key
      when Symbol then find_by_key(key)
      when String then find_by_key(key.to_sym) || find_by_id(key.to_i)
      when Fixnum then find_by_id(key)
      end
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
      where(args).first
    end

    def find_by_key(key)
      _values[key]
    end

    def find_by_id(id)
      _values[_symbol_index.key(id)]
    end
  end
end
