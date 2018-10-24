# frozen_string_literal: true

require "selenium/webdriver"
require "capybara"
require "capybara/dsl"

module Superbot
  module CLI
    module Cloud
      class RunCommand < Clamp::Command
        include Superbot::Validations

        option ['--region'], 'REGION', 'Region for remote webdriver'

        parameter "PATH", "the path to folder containing tests to upload" do |path|
          validates_project_path path
        end

        def execute
          register_remote_webdriver
          open_screenshots_stream
          run_test

          puts 'Press ENTER to exit.'
          $stdin.gets

          close_screenshot_stream
        end

        private

        def register_remote_webdriver
          puts "Attaching to remote webdriver..."

          ::Capybara.register_driver :chrome_remote do |app|
            ::Capybara::Selenium::Driver.new(
              app,
              browser: :remote,
              desired_capabilities: webdriver_capabilities,
              http_client: webriver_http_client,
              url: Superbot::Cloud.webdriver_url
            )
          end

          ::Capybara.current_driver = :chrome_remote
        end

        def webdriver_capabilities
          ::Selenium::WebDriver::Remote::Capabilities.chrome(
            chromeOptions: {
              'args' => [
                "--no-sandbox",
                "--disable-infobars",
                "--start-minimized",
                "--app=about:blank"
              ]
            },
            superOptions: region && { region: region } || {}
          )
        end

        def webriver_http_client
          ::Selenium::WebDriver::Remote::Http::Default.new.tap do |client|
            client.read_timeout = 2000
            client.open_timeout = 2000
          end
        end

        def open_screenshots_stream
          session_id = ::Capybara.current_session.driver.browser.send(:bridge).session_id
          puts "Opening test stream..."
          screenshots_url = Superbot::Cloud.screenshots_url(session_id)
          options = ::Selenium::WebDriver::Chrome::Options.new
          options.add_argument("app=#{screenshots_url}")
          @screenshots_stream = ::Selenium::WebDriver.for(:chrome, options: options)
        rescue ::Selenium::WebDriver::Error::ServerError => e
          abort "Remote webdriver error: #{e.message}"
        end

        def close_screenshot_stream
          @screenshots_stream&.quit
        end

        def run_test
          puts "Running test..."
          ::Capybara.send(:eval, test_script)
          puts "Succeed!"
        rescue ::Capybara::CapybaraError => e
          puts "Test failed!", e.message
        end

        def test_script
          @test_script ||= File.read(File.join(path, 'main.rb'))
        end
      end
    end
  end
end
