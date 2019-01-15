# frozen_string_literal: true

require 'fileutils'
require 'net/http/post/multipart'
require 'marcel'
require 'pathname'

module Superbot
  module Cloud
    module CLI
      module Test
        class UploadCommand < BaseCommand
          include Superbot::Validations

          parameter "PATH", "the path to folder containing tests to upload" do |path|
            validates_project_path(path)
          end

          def execute
            upload_tests
          end

          def upload_tests
            puts "Uploading files from #{path}..."
            files = Dir.glob(File.join(path, '*')).map do |test_file|
              filename = File.basename(test_file)
              content_type = Marcel::MimeType.for(Pathname.new(test_file), name: filename)
              UploadIO.new(File.open(test_file), content_type, filename)
            end
            test_name = Zaru.sanitize!(File.basename(path))

            api_response = Superbot::Cloud::Api.request(
              :test_upload,
              params: {
                name: test_name,
                organization_name: organization,
                'files[]': files
              }
            )

            puts "Successfully uploaded!"
            puts "Organization: #{api_response[:organization]}"
            puts "Test name: #{api_response[:name]}"
            puts("Files:", api_response[:files].map { |f| f[:filename].prepend('  ') })
          end
        end
      end
    end
  end
end
