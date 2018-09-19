# frozen_string_literal: true

require 'fileutils'
require 'net/http/post/multipart'

module Superbot
  module CLI
    module Cloud
      module Test
        class UploadCommand < Clamp::Command
          include Superbot::Validations

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
