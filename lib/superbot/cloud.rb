# frozen_string_literal: true

module Superbot
  module Cloud
    BASE_URI = "#{Superbot::URI_SCHEME}://#{Superbot::DOMAIN}"
    LOGIN_URI = "#{BASE_URI}/login/cloud"
    CREDENTIALS_PATH = File.join(Dir.home, '.superbot')
    private_constant :CREDENTIALS_PATH
    CREDENTIALS_FILE_PATH = File.join(CREDENTIALS_PATH, 'cloud_credentials.json')
    private_constant :CREDENTIALS_FILE_PATH

    def self.credentials
      all_credentials[Superbot::DOMAIN.to_sym]
    end

    def self.all_credentials
      @all_credentials ||=
        if File.exist?(CREDENTIALS_FILE_PATH)
          JSON.parse(File.read(CREDENTIALS_FILE_PATH), symbolize_names: true)
        else
          {}
        end
    end

    def self.save_credentials(data)
      all_credentials[Superbot::DOMAIN.to_sym] = data.transform_keys!(&:to_sym)
      FileUtils.mkdir_p CREDENTIALS_PATH
      File.write CREDENTIALS_FILE_PATH, all_credentials.to_json
      puts "Logged in as %<username>s (%<email>s)" % credentials.slice(:username, :email)
    end
  end
end

require_relative "cloud/version"
require_relative "cloud/api"
require_relative "cloud/cli"
require_relative "cloud/web_login"
