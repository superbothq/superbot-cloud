# frozen_string_literal: true

module Superbot
  module Cloud
    module CLI
      module Run
        class ScaleCommand < BaseCommand
          parameter "ID", "the ID of run to scale", required: true

          option ['--bots'], 'BOTS', 'number of active bots' do |bots|
            Integer(bots)
          end

          option ['--loop'], 'LOOP_COUNT', 'number of repeated invocations', attribute_name: :loop_count do |loop_count|
            Integer(loop_count)
          end

          def execute
            scale_run
          end

          def scale_run
            api_response = Superbot::Cloud::Api.request(:update_interactive_run, params: { id: id, organization_name: organization, parallel: bots, loop: loop_count }.compact)
            puts "Scaled"
            puts "bots: #{api_response[:parallel]}"
            puts "loop: #{api_response[:loop]}"
          end
        end
      end
    end
  end
end
