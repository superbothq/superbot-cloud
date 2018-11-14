# frozen_string_literal: true

require 'net/http/post/multipart'

module Superbot
  module Cloud
    module Api
      BASE_URI = "http://#{Superbot::DOMAIN}/api/v1"
      ENDPOINT_MAP = {
        login:             { method: :post, endpoint: 'sessions' },
        token:             { method: :post, endpoint: 'token' },
        organization_list: { method: :get, endpoint: 'organizations' },
        test_list:         { method: :get, endpoint: 'tests' },
        test_upload:       { method: :post_multipart, endpoint: 'tests' },
        delete_test:       { method: :delete, endpoint: 'tests', required_param: :name }
      }.freeze

      def self.request(type, params: {})
        method, endpoint, required_param = ENDPOINT_MAP[type].values
        uri = URI.parse([BASE_URI, endpoint, params[required_param]].compact.join('/'))

        req = Net::HTTP.const_get(
          method.to_s.split('_').map(&:capitalize).join('::')
        ).new(uri, params.compact)
        req.set_form_data(params.compact) unless method == :post_multipart
        if Superbot::Cloud.credentials
          req['Authorization'] = format(
            'Token token="%<token>s", email="%<email>s"',
            **Superbot::Cloud.credentials.slice(:email, :token)
          )
        end

        response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
          http.request(req)
        end
        parsed_response = response.class.body_permitted? && JSON.parse(response.body, symbolize_names: true) || {}
        return parsed_response if response.is_a? Net::HTTPSuccess

        abort parsed_response[:error]
      end
    end
  end
end
