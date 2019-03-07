# frozen_string_literal: true

module Superbot
  module Cloud
    module CLI
      module Schedule
        class ListCommand < BaseCommand
          OUTPUT_HEADERS = {
            id: { name: "ID", column_size: 10 },
            test_name: { name: "Test", column_size: 25 },
            starts_at: { name: "Scheduled Time", column_size: 20 },
            region: { name: "Region", column_size: 20 },
            status: { name: "Status", column_size: 15 },
            parallel: { name: "Bots", column_size: 10 },
            base_url: { name: "Base URL", column_size: 20 }
          }.freeze

          option %w[-q --quiet], :flag, "Only show schedule IDs"
          option %w[-a --all], :flag, "Show all the schedules (including finished)"

          def execute
            list_schedules
          end

          def list_schedules
            states = all? ? nil : %w[initial deployed aquired]
            api_response = Superbot::Cloud::Api.request(:schedule_list, params: { organization_name: organization, 'aasm_state[]': states })

            abort api_response[:error] if api_response[:error]
            abort "No active schedules found for organization #{api_response[:organization]}" if api_response[:schedules].empty?

            if quiet?
              puts(api_response[:schedules].map { |schedule| schedule[:id] })
            else
              puts "Organization: #{api_response[:organization]}"
              puts "Schedules:"
              puts OUTPUT_HEADERS.values.map { |header| header[:name].ljust(header[:column_size]) }.join
              api_response[:schedules].each do |schedule|
                row = schedule.slice(*OUTPUT_HEADERS.keys).map do |key, value|
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
