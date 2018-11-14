# frozen_string_literal: true

require 'sinatra'
require "sinatra/silent"
require 'fileutils'

module Superbot
  module Cloud
    class WebLogin
      def initialize
        @sinatra = Sinatra.new do
          set :bind, "127.0.0.1"
          set :silent_sinatra, true
          set :silent_webrick, true
          set :silent_access_log, false
          server_settings[:Silent] = true

          get "/login" do
            credentials = request.params.slice('username', 'email', 'token')
            Superbot::Cloud.save_credentials(credentials)
            redirect "#{Superbot::Cloud::LOGIN_URI}/success?username=#{Superbot::Cloud.credentials[:username]}"
          end
        end
      end

      def self.run!
        new.run!
      end

      def run!
        Thread.new do
          @sinatra.run!
        end
      end
    end
  end
end
