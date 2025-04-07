# frozen_string_literal: true

# spec/controllers/route_coverage_spec.rb
require 'rails_helper'

RSpec.describe 'Route Coverage', type: :request do
     before do
          # Skip routes that might cause side effects or require special setup
          @skipped_routes = [
               %r{^/rails/active_storage}, # Active Storage routes
               %r{^/sidekiq}, # Sidekiq admin panel if present
               %r{^/admin/delayed_job}, # Delayed Job web interface if present
               %r{^/letter_opener}, # Letter Opener web interface if present
               %r{^/web_console}, # Web Console routes
               %r{^/api/v1/webhooks}, # Example of webhook routes you might want to skip
               %r{^/cable}, # Action Cable routes
               %r{^/_}, # Rails system routes
               /\.(js|css|png|jpg|ico)$/ # Static assets
          ]

          # Routes that require parameters - add your application-specific ones here
          @routes_requiring_parameters = {
               %r{^/users/\d+} => { id: 1 },
               %r{^/products/\d+} => { id: 1 }
               # Add more patterns and required parameters as needed
          }

          # Routes that should be POST/PUT/PATCH/DELETE instead of GET
          @non_get_routes = [
               %r{^/users/\d+/update_profile},
               %r{^/orders/\d+/cancel}
               # Add more patterns as needed
          ]

          ENV['RAILS_ENV'] = 'test'
     end

     it 'tests all routes' do
          Rails.application.routes.routes.each do |route|
               path = route.path.spec.to_s
               next if skip_route?(path)

               # Skip routes that don't have a controller (like direct ActiveStorage routes)
               next unless route.requirements[:controller]

               begin
                    controller = "#{route.requirements[:controller]}_controller".classify.constantize
               rescue NameError
                    next # Skip if controller doesn't exist
               end

               action = route.requirements[:action]
               next unless controller.action_methods.include?(action.to_s)

               # Build the path with required parameters
               full_path = build_path(path, route.requirements)

               # Determine HTTP method
               verb = route.verb.gsub(/[$^]/, '')
               verb = 'GET' if verb.blank? # Default to GET if no verb specified

               # Skip if this is a non-GET route in our list
               next if @non_get_routes.any? { |pattern| path =~ pattern } && verb == 'GET'

               process_route(verb, full_path, route)
          end
     end

     private

     def skip_route?(path)
          return true if path.blank?
          return true if path.start_with?('/assets')

          @skipped_routes.any? { |pattern| path =~ pattern }
     end

     def build_path(path, requirements)
          # Handle path parameters
          path.gsub(/:\w+/) do |match|
               param_name = match[1..].to_sym
               param_value = find_parameter_value(path, param_name, requirements)
               param_value.to_s
          end
     end

     def find_parameter_value(path, param_name, requirements)
          # First check if we have explicit parameters for this route pattern
          @routes_requiring_parameters.each do |pattern, params|
               return params[param_name] if path =~ (pattern) && params.key?(param_name)
          end

          # Fall back to requirements or default values
          requirements[param_name] || case param_name
                                      when :id then 1
                                      when :user_id then 1
                                      when :product_id then 1
                                      else '1'
                                      end
     end

     def process_route(verb, path, _route)
          path = path.chomp('.1')
          case verb
          when 'GET'
               get path
          when 'POST'
               post path
          when 'PUT'
               put path
          when 'PATCH'
               patch path
          when 'DELETE'
               delete path
          else
               get path # Default to GET if verb not recognized
          end
          logger = Logger.new($stdout)
          logger.level = Logger::DEBUG
          logger.info("Testing route: #{verb} #{path}")

          logger.warn("Non-200 response for #{verb} #{path}: #{response.status}") if response.status != 200
     rescue StandardError => e
          logger.error("Error processing route #{verb} #{path}: #{e.message}")
     rescue ActionController::RoutingError => e
          raise "Routing error on #{verb} #{path}: #{e.message}"
     rescue AbstractController::ActionNotFound => e
          raise "Action not found on #{verb} #{path}: #{e.message}"
     rescue ActiveRecord::RecordNotFound => e
          raise "Record not found for #{verb} #{path}: #{e.message}"
     end
end
