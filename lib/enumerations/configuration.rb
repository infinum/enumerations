# frozen_string_literal: true

module Enumerations
  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end

  def self.restore_default_configuration
    @configuration = nil
  end

  class Configuration
    attr_accessor :primary_key
    attr_accessor :foreign_key_suffix
    attr_accessor :translate_attributes

    def initialize
      @primary_key          = nil
      @foreign_key_suffix   = nil
      @translate_attributes = true
    end
  end
end
