module Enumerations
  module Error
    class DuplicatedSymbol < RuntimeError; end
    class MissingPrimaryKey < RuntimeError; end
    class DuplicatedPrimaryKey < RuntimeError; end
    class InvalidValue < RuntimeError; end
  end
end
