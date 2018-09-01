require "base64"
require "json"
require 'rest-client'

module BcaStatement
  class Client
    attr_reader :access_token

    def initialize
      authentication
    end

    private

    def authentication
      # authentication to get access token
      url = "#{BcaStatement.configuration.base_url}/api/oauth/token"
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
