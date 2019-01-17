# frozen_string_literal: true

module Superbot
  module Cloud
    module CLI
      module Run
        class AbortCommand < BaseCommand
          parameter "ID ...", "the IDs of runs to abort", required: true

          def execute
            abort_run
          end

          def abort_run
            id_list.each do |run_id|
              Superbot::Cloud::Api.request(:abort_interactive_run, params: { id: run_id, organization_name: organization })
              puts "Interactive run #{run_id} successfully aborted"
            rescue SystemExit
              p # skip to next run
            end
          end
        end
      end
    end
  end
end
