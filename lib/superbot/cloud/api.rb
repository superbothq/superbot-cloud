# frozen_string_literal: true

module Superbot
  module Cloud
    module Api
      LOGIN_URI =         'https://superapp-staging.herokuapp.com/api/v1/sessions'
      TOKEN_URI =         'https://superapp-staging.herokuapp.com/api/v1/token'
      ORGANIZATIONS_URI = 'https://superapp-staging.herokuapp.com/api/v1/organizations'
      ENDPOINT_MAP = {
        login:             LOGIN_URI,
        token:             TOKEN_URI,
        organization_list: ORGANIZATIONS_URI
      }.freeze

      def self.request(type, method: :get)
        uri = URI.parse(ENDPOINT_MAP[type])
        req = Net::HTTP.const_get(method.to_s.capitalize).new(uri)
        if Superbot::Cloud.credentials
          req['Authorization'] = format(
            'Token token="%<token>s", email="%<email>s"',
            **Superbot::Cloud.credentials.slice(:email, :token)
          )
        end
        Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
          http.request(req)
        end
      end
    end
  end
end
