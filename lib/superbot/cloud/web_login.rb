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

          get "/login" do
            credentials = request.params.slice('email', 'token')
            request.params['error'] || Superbot::Cloud.save_credentials(credentials)
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
