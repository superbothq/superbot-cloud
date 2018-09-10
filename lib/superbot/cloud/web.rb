# frozen_string_literal: true

require 'sinatra'
require "sinatra/silent"
require 'fileutils'

module Superbot
  class Web
    def initialize
      @sinatra = Sinatra.new
      @sinatra.set :bind, "127.0.0.1"
      @sinatra.set :silent_sinatra, true
      @sinatra.set :silent_webrick, true
      @sinatra.set :silent_access_log, false

      @sinatra.before do
        headers['Access-Control-Allow-Methods'] = 'GET, POST, PUT, DELETE, OPTIONS'
        headers['Access-Control-Allow-Origin'] = '*'
        headers['Access-Control-Allow-Headers'] = 'accept, authorization, origin'
      end

      @sinatra.options '*' do
        response.headers['Allow'] = 'HEAD,GET,PUT,DELETE,OPTIONS,POST'
        response.headers['Access-Control-Allow-Headers'] = 'X-Requested-With, X-HTTP-Method-Override, Content-Type, Cache-Control, Accept'
      end

      @sinatra.get "/__superbot/v1/ping" do
        "PONG"
      end

      @sinatra.post "/__superbot/v1/convert" do
        body = JSON.parse(request.body.read)

        "visit 'http://example.com'\n#{body.inspect}"
      end

      @sinatra.get "/login" do
        if request.params['error']
          message = request.params['error']
        else
          path = `echo $HOME/.superbot`
          FileUtils.mkdir_p path
          File.write File.join(path, 'cloud_token.json'), request.params.slice('email', 'token').to_json
          message = "Logged in as #{request.params['email']}"
        end
        Thread.new { sleep 1; Process.kill 'INT', Process.pid }
        halt 200, message
        puts message
      end
    end

    def run!
      @sinatra.run_async!
    end

    def run_async_after_running!
      Thread.new do
        @sinatra.run!
      end

      loop do
        break if @sinatra.running?
        sleep 0.001
      end
    end
  end
end

