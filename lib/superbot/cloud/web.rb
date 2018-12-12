# frozen_string_literal: true

module Superbot
  module Cloud
    module Web
      def self.registered(sinatra)
        sinatra.get "/login" do
          credentials = request.params.slice('username', 'email', 'token')
          Superbot::Cloud.save_credentials(credentials)
          sinatra.quit!
          redirect "#{Superbot::Cloud::LOGIN_URI}/success?username=#{Superbot::Cloud.credentials[:username]}"
        end
      end
    end
  end
end
