# frozen_string_literal: true

module Superbot
  module Cloud
    LOGIN_URI = 'http://www.superbot.cloud/login/cloud'
    CREDENTIALS_PATH = File.join(Dir.home, '.superbot')
    private_constant :CREDENTIALS_PATH
    CREDENTIALS_FILE_PATH = File.join(CREDENTIALS_PATH, 'cloud_token.json')
    private_constant :CREDENTIALS_FILE_PATH

    def self.credentials
      return unless File.exist?(CREDENTIALS_FILE_PATH)

      @credentials ||= JSON.parse(File.read(CREDENTIALS_FILE_PATH), symbolize_names: true)
    end

    def self.save_credentials(data)
      data.transform_keys!(&:to_sym)
      FileUtils.mkdir_p Superbot::Cloud::CREDENTIALS_PATH
      File.write Superbot::Cloud::CREDENTIALS_FILE_PATH, data.to_json
      "Logged in as #{data[:email]}".tap do |message|
        puts message
      end
    end
  end
end

require_relative "cloud/version"
require_relative "cloud/api"
require_relative "cloud/cli"
require_relative "cloud/web_login"
