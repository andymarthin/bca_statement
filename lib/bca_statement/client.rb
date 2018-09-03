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
      @base_url = BcaStatement.configuration.base_url
      @corporate_id = BcaStatement.configuration.corporate_id
      @account_number = BcaStatement.configuration.account_number
      @api_key = BcaStatement.configuration.api_key
      @domain = BcaStatement.configuration.domain

      authentication
    end

     # Get your BCA Bisnis account statement for a period up to 31 days.
    def get_statement(start_date = '2016-08-29', end_date = '2016-09-01') 
      return nil unless @access_token

      @timestamp = Time.now.iso8601(3)
      @start_date = start_date.to_s
      @end_date = end_date.to_s
      @path = "/banking/v3/corporates/"
      @relative_url = "#{@path}#{@corporate_id}/accounts/#{@account_number}/statements?EndDate=#{@end_date}&StartDate=#{@start_date}"
      begin
        response = RestClient.get("#{@base_url}#{@relative_url}",
        "Content-Type": 'application/json',
        "Authorization": "Bearer #{@access_token}",
        "Origin": @domain,
        "X-BCA-Key": @api_key,
        "X-BCA-Timestamp":  @timestamp,
        "X-BCA-Signature": signature)
        elements = JSON.parse response.body
        statements = []

        elements['Data'].each do |element|
          year = Date.parse(@start_date).strftime('%m').to_i.eql?(12) ? Date.parse(@start_date).strftime('%Y') : Date.parse(@end_date).strftime('%Y')
          date = element['TransactionDate'].eql?("PEND") ? element['TransactionDate'] : "#{element['TransactionDate']}/#{year}"
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
      rescue RestClient::ExceptionWithResponse => err
        return nil
      end 
    end

    # Get your BCA Bisnis account balance information
    def balance
      return nil unless @access_token

      begin
        @timestamp = Time.now.iso8601(3)
        @relative_url = "/banking/v3/corporates/#{@corporate_id}/accounts/#{@account_number}"
        response = RestClient.get("#{@base_url}#{@relative_url}",
          "Content-Type": 'application/json',
          "Authorization": "Bearer #{@access_token}",
          "Origin": @domain,
          "X-BCA-Key": @api_key,
          "X-BCA-Timestamp":  @timestamp,
          "X-BCA-Signature": signature)

        data = JSON.parse response.body
        if account_detail_success = data['AccountDetailDataSuccess']
          detail = account_detail_success.first
            attribute = {
              account_number: detail['AccountNumber'],
              currency: detail['Currency'],
              balance: detail['Balance'].to_f,
              available_balance: detail['AvailableBalance'].to_f,
              float_amount: detail['FloatAmount'].to_f,
              hold_amount: detail['HoldAmount'].to_f
              plafon: detail['Plafon'].to_f
            }
          BcaStatement::Entities::Balance.new(attribute)
      
        else
          return nil
        end
      rescue RestClient::ExceptionWithResponse => err
        return nil
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
      begin
        url = "#{@base_url}/api/oauth/token"
        credential = "#{BcaStatement.configuration.client_id}:#{BcaStatement.configuration.client_secret}"
        authorization = { Authorization: "Basic #{Base64.strict_encode64(credential)}" }
        payload = { grant_type: 'client_credentials' }

        response = RestClient.post(url, payload, authorization)
        body = JSON.parse response.body
        @access_token = body['access_token']
      rescue RestClient::ExceptionWithResponse => err
        err.response
      end 
    end
  end
end
