# frozen_string_literal: true

module Superbot
  module Cloud
    module CLI
      module Run
        class ConsoleCommand < BaseCommand
          parameter "ID", "the ID of run to bots", required: true

          def execute
            abort "Run is not active anymore" if fetch_interaction[:status] == 'aborted'
            loop do
              printf '> '
              input = $stdin.gets
              exit if input.nil?
              cmd, arg = input.rstrip.split(' ')
              invoke_command(cmd, arg)
            end
          end

          private

          def invoke_command(command, argument)
            return if empty_value?(command)

            case command
            when 'bots', 'loops' then positive_number?(argument) && send(command, argument)
            when 'status', 'help', 'exit' then send(command)
            when 'abort' then abort_run
            else
              puts "Unknow command: #{command}"
            end
          end

          def common_request_params
            {
              id: id,
              organization_name: organization
            }
          end

          def bots(value)
            return puts("bots: #{fetch_interaction[:parallel].to_i}") if empty_value?(value)

            Superbot::Cloud::Api.request(:update_interactive_run, params: common_request_params.merge(parallel: value))
            puts "Number of bots scaled to #{value}"
          end

          def loops(value)
            return puts("loops: #{fetch_interaction[:loop].to_i}") if empty_value?(value)

            Superbot::Cloud::Api.request(:update_interactive_run, params: common_request_params.merge(loop: value))
            puts "Number of consecutive invocations scaled to #{value}"
          end

          def abort_run
            Superbot::Cloud::Api.request(:abort_interactive_run, params: common_request_params)
            abort "Abort requested"
          end

          def exit
            abort
          end

          def status
            puts(fetch_interaction.map { |arr| arr.join(': ') })
          end

          def fetch_interaction
            Superbot::Cloud::Api.request(:show_interactive_run, params: common_request_params)
          end

          def empty_value?(value)
            value.to_s.strip.empty?
          end

          def positive_number?(value)
            return true if empty_value?(value) || value =~ /\A\d+\z/

            puts("Incorrect argument value '#{value}', should be positive number or 0")
            false
          end

          def help
            puts "Interactive run commands:

                    bots              Output number of active bots
                    loops             Output number of consecutive invocations
                    bots [n]          Scale number of active bots to [n]
                    loops [n]         Scale number of consecutive invocations
                    status            Show current run info
                    abort             Abort current run and exit console
                    exit              Exit from console"
          end
        end
      end
    end
  end
end
