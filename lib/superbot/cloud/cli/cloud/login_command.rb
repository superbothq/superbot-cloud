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
          if Superbot::Cloud.credentials && !force?
            api_response = Superbot::Cloud::Api.request(:token, method: :post)
            if api_response.is_a?(Net::HTTPSuccess)
              puts "Logged in as #{Superbot::Cloud.credentials[:email]}"
            else
              interactive? ? console_login : web_login
            end
          else
            interactive? ? console_login : web_login
          end
        end

        def console_login
          email = (print 'Email: '; $stdin.gets.rstrip)
          password =  (print 'Password: '; $stdin.gets.rstrip)

          uri = URI.parse(Superbot::Cloud::Api::LOGIN_URI)
          req = Net::HTTP::Post.new(uri)
          req.content_type = 'multipart/form-data'
          req.set_form_data(email: email, password: password)
          res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
            http.request(req)
          end

          parsed_body = JSON.parse(res.body)
          return parsed_body['errors'] unless res.is_a?(Net::HTTPSuccess)

          FileUtils.mkdir_p Superbot::Cloud::CREDENTIALS_PATH, 775
          File.write Superbot::Cloud::CREDENTIALS_FILE_PATH, res.body
          puts "Logged in as #{parsed_body['email']}"
        end

        def web_login
          Superbot::Cloud::WebLogin.run!
          Launchy.open(cloud_login_uri)

          puts "Your browser has been opened to visit:"
          puts cloud_login_uri
          puts ""
          puts "Press enter to exit"
          $stdin.gets
        end

        def cloud_login_uri
          URI.parse(Superbot::Cloud::LOGIN_URI).tap do |uri|
            uri.query = URI.encode_www_form(redirect_uri: 'http://localhost:4567/login')
          end.to_s
        end
      end
    end
  end
end
