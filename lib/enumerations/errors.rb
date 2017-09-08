module Enumerations
  class Error < StandardError; end
  class DuplicatedSymbolError < Error; end
  class MissingPrimaryKeyError < Error; end
  class DuplicatedPrimaryKeyError < Error; end
  class InvalidValueError < Error; end
end
