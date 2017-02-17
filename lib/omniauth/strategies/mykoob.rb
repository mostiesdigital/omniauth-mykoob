require 'omniauth'
require 'rest_client'

module OmniAuth
  module Strategies
    #
    # Authenticate to mykoob.lv
    #
    # @example Basic Rails Usage
    #
    #  Add this to config/initializers/omniauth.rb
    #
    #    Rails.application.config.middleware.use OmniAuth::Builder do
    #      provider :mykoob, 'App id', 'API Key'
    #    end
    #
    # @example Basic Rack example
    #
    #  use Rack::Session::Cookie
    #  use OmniAuth::Strategies::Mykoob, 'App id', 'API Key'
    #
    class Mykoob
      include OmniAuth::Strategy

      args [:app_id, :api_key]

      protected

      def request_phase
        params = {
          client_id:     options.app_id,
          redirect_url:  callback_url,
          scope:         'user_info',
          response_type: 'code'
        }

        redirect "https://www.mykoob.lv/?oauth2/authorize/&#{stringify(params)}"
      end

      def callback_phase
        if request.params['code'].present?
          token_params   = {
            client_id:     options.app_id,
            client_secret: options.api_key,
            grant_type:    'authorization_code',
            code:          request.params['code']
          }
          token_response = RestClient.get("https://www.mykoob.lv/?oauth2/token/&#{stringify(token_params)}")
          access_token   = JSON.load(token_response).fetch('access_token')
          response       = RestClient.post('https://www.mykoob.lv/?oauth2/resource', {
            api:          'user_eduspace',
            access_token: access_token
          })

          @auth_data = JSON.load(response)
          super
        else
          fail!(:invalid_request)
        end
      rescue Exception => e
        fail!(:invalid_response, e)
      end

      uid { @auth_data['ID'] }

      info do
        {
          name:       [
                        @auth_data['Name'],
                        @auth_data['Middlename'],
                        @auth_data['Surname']
                      ].reject { |e| e.to_s.empty? }.join(' '),
          first_name: @auth_data['Name'],
          last_name:  @auth_data['Surname']
        }
      end

      extra do
        {
          user_hash: @auth_data
        }
      end

      private

      def stringify(params)
        params.collect do |key, value|
          "#{key}=#{Rack::Utils.escape(value)}"
        end.join('&')
      end
    end
  end
end
