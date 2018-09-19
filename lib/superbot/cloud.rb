# frozen_string_literal: true

module Superbot
  module Cloud
    LOGIN_URI = 'https://superapp-staging.herokuapp.com/login/cloud'
    CREDENTIALS_PATH = File.join(File.expand_path('~'), '.superbot')
    CREDENTIALS_FILE_PATH = File.join(CREDENTIALS_PATH, 'cloud_token.json')

    def self.credentials
      return unless File.exist?(CREDENTIALS_FILE_PATH)

      @credentials ||= JSON.parse(File.read(CREDENTIALS_FILE_PATH), symbolize_names: true)
    end
  end
end

require_relative "cloud/version"
require_relative 'cloud/api'
require_relative "cloud/cli"
require_relative "cloud/web_login"
