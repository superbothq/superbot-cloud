# frozen_string_literal: true

module Superbot
  module Cloud
    module Web
      def self.registered(sinatra)
        sinatra.get "/login" do
          credentials = request.params.slice('username', 'email', 'token', 'organization')
          Superbot::Cloud.save_credentials(credentials)
          puts "Logged in as #{credentials[:username]} (#{credentials[:email]})"
          redirect "#{Superbot::Cloud::LOGIN_URI}/success"
        end

        sinatra.after "/login" do
          sleep 1
          sinatra.quit!
        end
      end
    end
  end
end
