# frozen_string_literal: true

require 'fileutils'
require 'pathname'

module Superbot
  module Cloud
    module CLI
      module Test
        class DownloadCommand < BaseCommand
          include Superbot::Cloud::Validations

          parameter "NAME", "the name of test to download"

          def execute
            require_login
            download_test
          end

          def download_test
            puts "Downloading #{name}..."
            test = Superbot::Cloud::Api.request(
              :test_download,
              params: {
                name: name,
                organization_name: organization
              }
            )

            if Dir.exist?(test[:name])
              puts "Directory #{test[:name]} already exists"
              print "Override files? [Y/n] "
              answer = $stdin.gets.rstrip
              abort "Aborted." unless answer.downcase.start_with?('y') || answer.empty?
            end

            FileUtils.mkdir_p test[:name]
            test[:files].each do |file|
              File.write(File.join(test[:name], file[:filename]), file[:content])
              print file[:filename], ' - ', 'Success'
              puts
            end
            puts "Test files successfully downloaded to #{File.join(Dir.pwd, test[:name])}"
          end
        end
      end
    end
  end
end
