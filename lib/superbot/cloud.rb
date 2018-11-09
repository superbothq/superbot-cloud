# frozen_string_literal: true

module Superbot
  module Cloud
    LOGIN_URI = "http://#{Superbot::DOMAIN}/login/cloud"
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
      FileUtils.mkdir_p CREDENTIALS_PATH
      File.write CREDENTIALS_FILE_PATH, data.to_json
      puts "Logged in as #{data[:username]} (#{data[:email]})"
    end
  end
end

require_relative "cloud/version"
require_relative "cloud/api"
require_relative "cloud/cli"
require_relative "cloud/web_login"
