module Enumeration
  Reflection = Struct.new(:name, :options) do
    def class_name
      options[:class_name]
    end

    def foreign_key
      options[:foreign_key]
    end
  end
end
