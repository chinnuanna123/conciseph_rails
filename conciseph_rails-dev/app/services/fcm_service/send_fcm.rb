# frozen_string_literal: true

require 'fcm'
module FcmService
  class SendFcm < FcmService::BaseService
    attr_reader :fcm_tokens, :title, :body, :data

    def initialize(users, title, body, data = {})
      super(users)
      @fcm_tokens = get_fcm_token(users)
      @title = title
      @body = body
      @data = data
    end

    def call
      message = build_message
      fcm_tokens.each do |token|
        message.merge!(token: token)
      end
      fcm.send_v1(message)
    end

    def build_message
      {
        notification: notification,
        data: data
      }
    end

    def notification
      {
        title: title,
        body: body
      }
    end

    def get_fcm_token(users)
      return [users.fcm_token] if users.instance_of?(User)

      users.map(&:fcm_token).compact!
    end
  end
end
