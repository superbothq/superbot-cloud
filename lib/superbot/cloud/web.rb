# frozen_string_literal: true

module Superbot
  module Cloud
    module Web
      def self.registered(sinatra)
        sinatra.get "/login" do
          credentials = request.params.slice('username', 'email', 'token')
          Superbot::Cloud.save_credentials(credentials)
          redirect "#{Superbot::Cloud::LOGIN_URI}/success"
        end

        sinatra.after "/login" do
          sinatra.quit!
        end
      end
    end
  end
end
