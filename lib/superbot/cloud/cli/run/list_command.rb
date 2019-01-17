# frozen_string_literal: true

module Superbot
  module Cloud
    module CLI
      module Run
        class ListCommand < BaseCommand
          OUTPUT_HEADERS = {
            id: { name: "ID", column_size: 10 },
            test_name: { name: "Test", column_size: 25 },
            region: { name: "Region", column_size: 20 },
            status: { name: "Status", column_size: 10 },
            parallel: { name: "Bots", column_size: 10 },
            loop: { name: "Loop count", column_size: 10 }
          }.freeze

          option %w[-q --quiet], :flag, "Only show interactive run IDs"
          option %w[-a --all], :flag, "Show all the interactive runs (including finished)"

          def execute
            list_interactive_runs
          end

          def list_interactive_runs
            states = all? ? nil : %w[initial running]
            api_response = Superbot::Cloud::Api.request(:interactive_run_list, params: { organization_name: organization, 'aasm_state[]': states })

            abort api_response[:error] if api_response[:error]
            abort "No active interactive runs found for organization #{api_response[:organization]}" if api_response[:interactive_runs].empty?

            if quiet?
              puts(api_response[:interactive_runs].map { |interactive_run| interactive_run[:id] })
            else
              puts "Organization: #{api_response[:organization]}"
              puts "Interactive runs:"
              puts OUTPUT_HEADERS.values.map { |header| header[:name].ljust(header[:column_size]) }.join
              api_response[:interactive_runs].each do |interactive_run|
                row = interactive_run.slice(*OUTPUT_HEADERS.keys).map do |key, value|
                  value.to_s.ljust(OUTPUT_HEADERS.dig(key, :column_size))
                end.join
                puts row
              end
            end
          end
        end
      end
    end
  end
end
