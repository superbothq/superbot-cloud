# frozen_string_literal: true

require 'net/http/post/multipart'

module Superbot
  module Cloud
    module Api
      BASE_URI = "#{Superbot::Cloud::BASE_URI}/api/v1"
      ENDPOINT_MAP = {
        token:                      { method: :post, endpoint: 'token' },
        organization_list:          { method: :get, endpoint: 'organizations' },
        test_list:                  { method: :get, endpoint: 'tests' },
        test_upload:                { method: :post_multipart, endpoint: 'tests' },
        test_download:              { method: :get, endpoint: 'tests', required_param: :name },
        delete_test:                { method: :delete, endpoint: 'tests', required_param: :name },
        schedule_test:              { method: :post, endpoint: 'schedules' },
        schedule_list:              { method: :get, endpoint: 'schedules' },
        cancel_schedule:            { method: :delete, endpoint: 'schedules', required_param: :id },
        webdriver_session_list:     { method: :get, endpoint: 'webdriver_sessions' },
        delete_webdriver_session:   { method: :delete, endpoint: 'webdriver_sessions', required_param: :session_id },
        get_webdriver_session:      { method: :get, endpoint: 'webdriver_sessions', required_param: :session_id },
        member_list:                { method: :get, endpoint: 'members' },
        add_member:                 { method: :post, endpoint: 'members' },
        remove_member:              { method: :delete, endpoint: 'members', required_param: :username },
        create_interactive_run:     { method: :post, endpoint: 'interactive_runs' },
        abort_interactive_run:      { method: :delete, endpoint: 'interactive_runs', required_param: :id },
        update_interactive_run:     { method: :patch, endpoint: 'interactive_runs', required_param: :id },
        show_interactive_run:       { method: :get, endpoint: 'interactive_runs', required_param: :id },
        interactive_run_list:       { method: :get, endpoint: 'interactive_runs' },
        access_token_list:          { method: :get, endpoint: 'access_tokens' },
        create_access_token:        { method: :post, endpoint: 'access_tokens' },
        revoke_access_token:        { method: :delete, endpoint: 'access_tokens', required_param: :token }
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

        auth_token = ENV['SUPERBOT_TOKEN'] || Superbot::Cloud.credentials&.slice(:username, :token)&.values&.join(':')
        if auth_token
          auth_type = ENV['SUPERBOT_TOKEN'] ? 'Bearer' : 'Basic'
          req['Authorization'] = "#{auth_type} #{Base64.urlsafe_encode64(auth_token)}"
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
