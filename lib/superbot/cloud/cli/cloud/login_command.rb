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
          if File.exist?(Superbot::Cloud::CREDENTIALS_FILE_PATH) && !force?
            credentials = JSON.parse(File.read(Superbot::Cloud::CREDENTIALS_FILE_PATH))

            if credentials_login_request(credentials).code == '200'
              puts "Logged in as #{credentials['email']}"
            else
              interactive? ? console_login : web_login
            end
          else
            interactive? ? console_login : web_login
          end
        end

        def cloud_uri
          URI.parse(Superbot::Cloud::CLOUD_URI).tap do |uri|
            uri.query = URI.encode_www_form(redirect_uri: 'http://localhost:4567/login')
          end
        end

        def credentials_login_request(credentials)
          uri = URI.parse(Superbot::Cloud::CLOUD_API_TOKEN_URI)
          req = Net::HTTP::Post.new(uri)
          req['Authorization'] = format('Token email=%<email>s, token="%<token>s"', email: credentials['email'], token: credentials['token'])
          res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
            http.request(req)
          end
        end

        def console_login
          email = (print 'Email: '; $stdin.gets.rstrip)
          password =  (print 'Password: '; $stdin.gets.rstrip)

          uri = URI.parse(Superbot::Cloud::CLOUD_API_URI)
          req = Net::HTTP::Post.new(uri)
          req.content_type = 'multipart/form-data'
          req.set_form_data(email: email, password: password)
          res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
            http.request(req)
          end

          parsed_body = JSON.parse(res.body)

          return parsed_body['errors'] if parsed_body['errors']

          FileUtils.mkdir_p Superbot::Cloud::CREDENTIALS_PATH, 775
          File.write Superbot::Cloud::CREDENTIALS_FILE_PATH, res.body
          puts "Logged in as #{parsed_body['email']}"
        end

        def web_login
          web = Superbot::Cloud::WebLogin.new
          web.run!
          Launchy.open(cloud_uri.to_s)

          puts "🤖 active"
          puts ""
          puts "Press enter to exit"
          $stdin.gets
        end
      end
    end
  end
end
