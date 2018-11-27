# frozen_string_literal: true

require 'net/http/post/multipart'

module Superbot
  module Cloud
    module Api
      BASE_URI = "#{Superbot::URI_SCHEME}://#{Superbot::DOMAIN}/api/v1"
      ENDPOINT_MAP = {
        login:                    { method: :post, endpoint: 'sessions' },
        token:                    { method: :post, endpoint: 'token' },
        organization_list:        { method: :get, endpoint: 'organizations' },
        test_list:                { method: :get, endpoint: 'tests' },
        test_upload:              { method: :post_multipart, endpoint: 'tests' },
        delete_test:              { method: :delete, endpoint: 'tests', required_param: :name },
        webdriver_session_list:   { method: :get, endpoint: 'webdriver_sessions' },
        delete_webdriver_session: { method: :delete, endpoint: 'webdriver_sessions', required_param: :session_id }
      }.freeze

      def self.request(type, params: {})
        method, endpoint, required_param = ENDPOINT_MAP[type].values
        uri = URI.parse([BASE_URI, endpoint, params[required_param]].compact.join('/'))

        request_class = Net::HTTP.const_get(method.to_s.split('_').map(&:capitalize).join('::'))

        params = params.compact
        req =
          case method
          when :get
            uri.query = URI.encode_www_form(params)
            req = request_class.new(uri)
          when :post_multipart
            request_class.new(uri, params)
          else
            request_class.new(uri).tap { |r| r.set_form_data(params) }
          end

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
