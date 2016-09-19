module Enumerations
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  def self.restore_default_configuration
    self.configuration = nil
    configure {}
  end

  class Configuration
    attr_accessor :primary_key
    attr_accessor :foreign_key_suffix

    def initialize
      @primary_key        = nil
      @foreign_key_suffix = nil
    end
  end
end
