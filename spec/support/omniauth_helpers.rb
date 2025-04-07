# frozen_string_literal: true

module OmniauthHelpers
     def setup_devise_mapping
          @request.env['devise.mapping'] = Devise.mappings[:member]
     end
end

RSpec.configure do |config|
     config.include OmniauthHelpers, type: :request
end

# Add to config/initializers/devise.rb:
# config.warden do |manager|
#   manager.failure_app = CustomFailureApp
# end

# Add to config/routes.rb:
# devise_scope :member do
#   get '/members/auth/failure', to: 'omniauth_callbacks#failure'
# end

# Add to omniauth_callbacks_controller.rb:
def failure
     flash[:alert] = t('devise.omniauth_callbacks.failure', kind: OmniAuth::Utils.camelize(failed_strategy.name),
                                                            reason: failure_message)
     redirect_to new_member_session_path
end

  private

def failed_strategy
     request.env['omniauth.error.strategy'] || request.env['omniauth.strategy']
end

def failure_message
     message = request.env['omniauth.error.type']
     message ||= request.params['message'] if request.params['message']
     message || 'unknown'
end
