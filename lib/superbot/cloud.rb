module Superbot
  module Cloud
    CLOUD_URI = 'https://superapp-staging.herokuapp.com/login/cloud'.freeze
    CLOUD_API_URI = 'https://superapp-staging.herokuapp.com/api/v1/sessions'.freeze
    CLOUD_API_TOKEN_URI = 'https://superapp-staging.herokuapp.com/api/v1/token'.freeze
    CREDENTIALS_PATH = File.join(ENV['HOME'], '.superbot').freeze
    CREDENTIALS_FILE_PATH = File.join(CREDENTIALS_PATH, 'cloud_token.json').freeze
  end
end

require_relative "cloud/version"
require_relative "cloud/cli"
require_relative "cloud/web_login"
