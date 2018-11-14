# frozen_string_literal: true

require 'net/http'
require 'launchy'

module Superbot
  module CLI
    module Cloud
      class LoginCommand < Clamp::Command
        option ['-i', '--interactive'], :flag, 'interactive login from command line'
        option ['-f', '--force'], :flag, 'force override current credentials'

        def execute
          return proceed_to_login if force? || Superbot::Cloud.credentials.nil?

          begin
            Superbot::Cloud::Api.request(:token)
            user_creds = Superbot::Cloud.credentials
            puts "Logged in as #{user_creds[:username]} (#{user_creds[:email]})"
          rescue SystemExit => e.message
            abort unless e.message == 'Invalid credentials'
            proceed_to_login
          end
        end

        def proceed_to_login
          interactive? ? console_login : web_login
        end

        def console_login
          email = (print 'Email: '; $stdin.gets.rstrip)
          password = (print 'Password: '; $stdin.gets.rstrip)
          api_response = Superbot::Cloud::Api.request(:login, params: { email: email, password: password })
          Superbot::Cloud.save_credentials(api_response)
        end

        def web_login
          web = Superbot::Cloud::WebLogin.new
          web.run_async_after_running!
          open_cloud_login_uri
          handle_keyboard_interrupt
          wait_for_login(web)
        end

        def open_cloud_login_uri
          cloud_login_uri = URI.parse(Superbot::Cloud::LOGIN_URI).tap do |uri|
            uri.query = URI.encode_www_form(redirect_uri: 'http://localhost:4567/login')
          end.to_s

          Launchy.open(cloud_login_uri)
          puts "Your browser has been opened to visit:", cloud_login_uri
          puts
        end

        def handle_keyboard_interrupt
          trap "SIGINT" do
            puts
            puts "Command killed by keyboard interrupt"
            exit 130
          end
        end

        def wait_for_login(web)
          loop do
            break unless web.running?

            sleep 0.1
          end
        end
      end
    end
  end
end
