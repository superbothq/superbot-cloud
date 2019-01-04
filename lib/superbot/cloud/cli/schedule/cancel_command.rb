# frozen_string_literal: true

module Superbot
  module Cloud
    module CLI
      module Schedule
        class CancelCommand < BaseCommand
          parameter "ID ...", "the IDs of the schedule to cancel", required: true

          def execute
            delete_schedule
          end

          def delete_schedule
            id_list.each do |schedule_id|
              begin
                Superbot::Cloud::Api.request(:cancel_schedule, params: { id: schedule_id, organization_name: organization })
                puts "Test schedule #{schedule_id} successfully cancelled"
              rescue SystemExit
                p # skip to next schedule
              end
            end
          end
        end
      end
    end
  end
end
