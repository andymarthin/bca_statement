module BcaStatement
  class Configuration
    attr_accessor :client_id, :client_secret, :corporate_id, :account_number, :api_key, :api_secret, :base_url, :domain

    def initialize
      @client_id = nil
      @client_secret = nil 
      @corporate_id = nil
      @account_number = nil
      @api_key = nil
      @api_secret = nil
      @base_url = nil
      @domain = nil
    end
  end
end
