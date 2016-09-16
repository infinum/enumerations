module Enumerations
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  class Configuration
    attr_accessor :primary_key

    def initialize
      @primary_key = nil
    end
  end
end
