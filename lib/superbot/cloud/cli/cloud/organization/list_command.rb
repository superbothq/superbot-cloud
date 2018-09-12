# frozen_string_literal: true

require 'net/http'
require 'launchy'

module Superbot
  module CLI
    module Cloud
      module Organization
        class ListCommand < Clamp::Command
          def execute
            abort "You are not logged in, use `superbot cloud login` to login" unless Superbot::Cloud.credentials
            list_organizations
          end

          def list_organizations
            res = Superbot::Cloud::Api.request(:organization_list)
            parsed_body = JSON.parse(res.body, symbolize_names: true)
            abort parsed_body[:errors] unless res.code == '200'
            parsed_body.each do |organization|
              puts organization[:name]
            end
          end
        end
      end
    end
  end
end
