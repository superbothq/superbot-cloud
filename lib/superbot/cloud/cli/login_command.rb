# frozen_string_literal: true

require 'net/http'
require 'launchy'

module Superbot
  module Cloud
    module CLI
      class LoginCommand < Clamp::Command
        option ['-f', '--force'], :flag, 'force override current credentials'

        def execute
          return web_login if force? || Superbot::Cloud.credentials.nil?

          begin
            Superbot::Cloud::Api.request(:token)
            user_creds = Superbot::Cloud.credentials
            puts "Logged in as #{user_creds[:username]} (#{user_creds[:email]})"
          rescue SystemExit => e
            abort unless e.message == 'Invalid credentials'
            web_login
          end
        end

        def web_login
          open_cloud_login_uri
          Superbot::Web.run!
        end

        def open_cloud_login_uri
          cloud_login_uri = URI.parse(Superbot::Cloud::LOGIN_URI).tap do |uri|
            uri.query = URI.encode_www_form(redirect_uri: 'http://localhost:4567/login')
          end.to_s

          Launchy.open(cloud_login_uri)
          puts "Your browser has been opened to visit:", cloud_login_uri
          puts
        end
      end
    end
  end
end
