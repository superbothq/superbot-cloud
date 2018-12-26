# frozen_string_literal: true

module Superbot
  module Cloud
    module CLI
      module Test
        class DeleteCommand < BaseCommand
          parameter "NAME", "the name of the test to delete", required: true

          def execute
            delete_test
          end

          def delete_test
            Superbot::Cloud::Api.request(:delete_test, params: { name: name, organization_name: organization })
            puts "Tests successfully deleted"
          end
        end
      end
    end
  end
end
