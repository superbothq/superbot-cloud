# frozen_string_literal: true

require 'zaru'
require 'fileutils'
require 'net/http/post/multipart'

module Superbot
  module CLI
    module Cloud
      module Test
        class UploadCommand < Clamp::Command
          parameter "PATH", "the path to folder containing tests to upload" do |path|
            unless path == Zaru.sanitize!(path)
              raise ArgumentError, "#{path} is not valid name for a directory"
            end

            unless Dir.exist? path
              raise ArgumentError, "directory #{path} does not exist"
            end

            path
          end

          option ["-o", "--org"], "ORGANIZATION", "Organization to list tests for", attribute_name: :organization

          def execute
            abort "You are not logged in, use `superbot cloud login` to login" unless Superbot::Cloud.credentials
            upload_tests
          end

          def upload_tests
            Dir.glob(File.join(path, '*.rb')) do |test_file|
              File.open(test_file) do |file|
                res = Superbot::Cloud::Api.request(
                  :test_upload,
                  params: {
                    organization_name: organization,
                    file: UploadIO.new(file, 'text/plain', File.basename(test_file))
                  }
                )
                parsed_body = JSON.parse(res.body, symbolize_names: true)
                puts parsed_body
              end
            end
          end
        end
      end
    end
  end
end
