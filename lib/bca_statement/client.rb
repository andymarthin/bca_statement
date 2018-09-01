require "base64"
require "json"
require 'time'
require 'date'
require 'openssl'
require 'rest-client'
require 'byebug'

module BcaStatement
  class Client
    attr_reader :access_token

    def initialize
      @timestamp = Time.now.iso8601(3)
      @base_url = BcaStatement.configuration.base_url
      authentication
    end

    def get_statement(start_date = '2016-08-29', end_date = '2016-09-01')
      @start_date = start_date.to_s
      @end_date = end_date.to_s
      @path = "/banking/v3/corporates/"
      @corporate_id = BcaStatement.configuration.corporate_id
      @account_number = BcaStatement.configuration.account_number
      @relative_url = "#{@path}#{@corporate_id}/accounts/#{@account_number}/statements?EndDate=#{@end_date}&StartDate=#{@start_date}"
      response = RestClient.get("#{@base_url}#{@relative_url}",
        "Content-Type": 'application/json',
        "Authorization": "Bearer #{@access_token}",
        "Origin": BcaStatement.configuration.domain,
        "X-BCA-Key": BcaStatement.configuration.api_key,
        "X-BCA-Timestamp":  @timestamp,
        "X-BCA-Signature": signature)
      if response.code.eql?(200)
        elements = JSON.parse response.body
        statements = []

        elements['Data'].each do |element|
          year = Date.parse(@start_date).strftime('%m').to_i.eql?(12) ? Date.parse(@start_date).strftime('%Y') : Date.parse(@end_date).strftime('%Y')
          date = "#{element['TransactionDate']}/#{year}"
          attribute = {
            date: date,
            brance_code: element['BranchCode'],
            type: element['TransactionType'],
            amount: element['TransactionAmount'].to_f,
            name: element['TransactionName'],
            trailer: element['Trailer']
          }
          statements << BcaStatement::Entities::Statement.new(attribute)
        end
        statements
      else
        return
      end

    end

    private

    def signature
      body = Digest::SHA256.hexdigest('').downcase
      string_to_sign = "GET:#{@relative_url}:#{@access_token}:#{body}:#{@timestamp}"
      OpenSSL::HMAC.hexdigest('SHA256', BcaStatement.configuration.api_secret, string_to_sign)
    end

    def authentication
      # authentication to get access token
      url = "#{@base_url}/api/oauth/token"
      credential = "#{BcaStatement.configuration.client_id}:#{BcaStatement.configuration.client_secret}"
      authorization = { Authorization: "Basic #{Base64.strict_encode64(credential)}" }
      payload = { grant_type: 'client_credentials' }

      response = RestClient.post(url, payload, authorization)
      if response.code.eql?(200)
        body = JSON.parse response.body
        @access_token = body['access_token']
      end
    end
  end
end
