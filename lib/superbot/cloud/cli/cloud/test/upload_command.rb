# frozen_string_literal: true

require 'fileutils'
require 'net/http/post/multipart'
require 'marcel'
require 'pathname'

module Superbot
  module CLI
    module Cloud
      module Test
        class UploadCommand < Clamp::Command
          include Superbot::Cloud::Validations

          parameter "PATH", "the path to folder containing tests to upload"

          option ["-o", "--org"], "ORGANIZATION", "Organization to upload tests for", attribute_name: :organization

          def execute
            require_login
            upload_tests
          end

          def upload_tests
            puts "Uploading files from #{path}..."
            Dir.glob(File.join(path, '*')) do |test_file|
              filename = File.basename(test_file)
              content_type = Marcel::MimeType.for(Pathname.new(test_file), name: filename)

              File.open(test_file) do |file|
                api_response = Superbot::Cloud::Api.request(
                  :test_upload,
                  params: {
                    name: Zaru.sanitize!(path),
                    organization_name: organization,
                    file: UploadIO.new(file, content_type, filename)
                  }
                )

                print filename, ' - ', api_response[:errors] || 'Success'
                puts
              end
            end
          end
        end
      end
    end
  end
end
