# frozen_string_literal: true

module Superbot
  module Cloud
    module CLI
      module Test
        class DeleteCommand < BaseCommand
          parameter "NAME ...", "the name of the test to delete", required: true

          def execute
            delete_test
          end

          def delete_test
            name_list.each do |name|
              Superbot::Cloud::Api.request(:delete_test, params: { name: name, organization_name: organization })
              puts "Tests #{name} successfully deleted"
            rescue SystemExit => e
              puts "Test #{name} removal failed: #{e.message}"
            end
          end
        end
      end
    end
  end
end
