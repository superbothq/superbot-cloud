# frozen_string_literal: true

require 'net/http/post/multipart'

module Superbot
  module Cloud
    module Api
      BASE_URI = "https://superapp-staging.herokuapp.com/api/v1/"
      ENDPOINT_MAP = {
        login:             { method: :post, endpoint: 'sessions' },
        token:             { method: :post, endpoint: 'token' },
        organization_list: { method: :get, endpoint: 'organizations' },
        test_list:         { method: :get, endpoint: 'tests' },
        test_upload:       { method: :post_multipart, endpoint: 'tests' }
      }.freeze

      def self.request(type, params: {})
        method = ENDPOINT_MAP.dig(type, :method).to_s
        uri = URI.join(BASE_URI, ENDPOINT_MAP.dig(type, :endpoint))

        req = Net::HTTP.const_get(
          method.split('_').map(&:capitalize).join('::')
        ).new(uri, params.compact)
        req.set_form_data(params.compact) unless method == 'post_multipart'
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
