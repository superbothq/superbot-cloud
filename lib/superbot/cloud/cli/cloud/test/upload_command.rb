# frozen_string_literal: true

require 'fileutils'
require 'net/http/post/multipart'

module Superbot
  module CLI
    module Cloud
      module Test
        class UploadCommand < Clamp::Command
          include Superbot::Validations
          include Superbot::Cloud::Validations

          parameter "PATH", "the path to folder containing tests to upload" do |path|
            validates_project_path path
          end

          option ["-o", "--org"], "ORGANIZATION", "Organization to upload tests for", attribute_name: :organization

          def execute
            require_login
            upload_tests
          end

          def upload_tests
            Dir.glob(File.join(path, '*.rb')) do |test_file|
              puts "Uploading files from #{path}..."
              filename = File.basename(test_file)
              content_type = mime_type_of(test_file)
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

          def mime_type_of(file)
            `file -b --mime-type #{file}`.strip
          end
        end
      end
    end
  end
end
