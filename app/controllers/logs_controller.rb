# frozen_string_literal: true

class LogsController < MemberController
     before_action :restrict_non_admins
     def download
          log_path = Rails.root.join('log/admin.log')
          lines = tail(log_path, lines: 500)

          send_data lines.join,
                    filename: 'admin_log.txt',
                    type: 'text/plain',
                    disposition: 'attachment'

          Rails.logger.warn("User #{current_member.id} downloaded the log file")
     end

     private

     def tail(file_path, lines: 400)
          return [] unless File.exist?(file_path)

          buffer = []
          File.foreach(file_path) do |line|
               buffer << line
               buffer.shift if buffer.size > lines
          end
          buffer
     end
end
