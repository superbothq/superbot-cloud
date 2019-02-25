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
    end

    def self.remove_credentials
      abort "You are not logged in yet." unless credentials
      all_credentials.delete(Superbot::DOMAIN.to_sym)
      File.write CREDENTIALS_FILE_PATH, all_credentials.to_json
    end

    def self.authorization_header
      @authorization_header ||= format(
        '%<auth_type>s %<auth_token>s',
        auth_type: ENV['SUPERBOT_TOKEN'] ? 'Bearer' : 'Basic',
        auth_token: Base64.urlsafe_encode64(
          ENV.fetch(
            'SUPERBOT_TOKEN',
            credentials&.values_at(:username, :token)&.join(':').to_s
          )
        )
      )
    end
  end
end

require_relative "cloud/version"
require_relative "cloud/api"
require_relative "cloud/web"
require_relative "cloud/cli"
