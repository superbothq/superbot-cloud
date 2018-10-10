# frozen_string_literal: true

module Superbot
  module CLI
    module Cloud
      module Test
        class DeleteCommand < Clamp::Command
          include Superbot::Cloud::Validations

          option ["-o", "--org"], "ORGANIZATION", "Organization to search test for deletion", attribute_name: :organization
          parameter "NAME", "the name of the test to delete", required: true

          def execute
            require_login
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
