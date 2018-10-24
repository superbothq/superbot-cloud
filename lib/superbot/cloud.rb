# frozen_string_literal: true

module Superbot
  module Cloud
    LOGIN_URI = 'http://www.superbot.cloud/login/cloud'
    CREDENTIALS_PATH = File.join(Dir.home, '.superbot')
    CREDENTIALS_FILE_PATH = File.join(CREDENTIALS_PATH, 'cloud_token.json')
    SCREENSHOTS_BASE_URL = {
      local: "http://localhost:3002/v1",
      remote: "http://peek.superbot.cloud/v1"
    }.freeze
    WEBDRIVER_URL = {
      local: "http://localhost:3000/webdriver/v1",
      remote: "http://webdriver.superbot.cloud:3000/webdriver/v1"
    }.freeze
    WEBDRIVER_TYPE = :remote # use :local if you are running superbot webdriver cluster locally

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

    def self.webdriver_url
      WEBDRIVER_URL[WEBDRIVER_TYPE]
    end

    def self.screenshots_url(session_id)
      "#{SCREENSHOTS_BASE_URL[WEBDRIVER_TYPE]}/#{session_id}"
    end
  end
end

require_relative "cloud/version"
require_relative "cloud/api"
require_relative "cloud/cli"
require_relative "cloud/web_login"
