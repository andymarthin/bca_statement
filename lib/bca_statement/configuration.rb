module BcaStatement
  class Configuration
    attr_accessor :client_id, :client_secret, :corporate_id, :account_number, :api_key, :api_secret, :base_url, :domain

    def initialize
      @client_id = nil
      @client_secret = nil 
      @corporate_id = 'BCAAPI2016'
      @account_number = '0201245680'
      @api_key = nil
      @api_secret = nil
      @base_url = 'https://sandbox.bca.co.id'
      @domain = nil
    end
  end
end
