# frozen_string_literal:true

module FcmService
  class BaseService
    attr_reader :fcm

    def initialize(_abc)
      @fcm = FCM.new(
        credential_file_path,
        project_id
      )
    end

    def credential_file_path
      Rails.root.join('config/credentials/concisephonline.json').to_s
    end

    def project_id
      'concise-ph'
    end

    # def api_key
    #   'a9494e9d48b0c9162709fe27314f18b9ce500b43'
    # end
  end
end
