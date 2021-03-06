require "bca_statement/version"
require "bca_statement/configuration"
require "bca_statement/error"
require "bca_statement/entities/base"
require "bca_statement/client"

module BcaStatement
  class << self
    attr_accessor :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.reset
    @configuration = Configuration.new
  end

  def self.configure
    yield(configuration)
  end
  
end
