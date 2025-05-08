# frozen_string_literal: true

class ActionStep < ApplicationRecord
  # belongs_to :actionable, polymorphic: true
  belongs_to :milestone
  has_one :user_action_step

  before_save :set_artifact_type_val

  has_one_attached :artifact_document
  has_one_attached :artifact_video

  has_many :user_action_steps

  scope :with_relevant_attachment, lambda {
    artifact_arr = pluck(:artifact_type).uniq
    doc = artifact_arr.include?('document')
    vid = artifact_arr.include?('video')
    if doc && vid
      includes(artifact_document_attachment: :blob, artifact_video_attachment: :blob)
    elsif doc
      includes(artifact_document_attachment: :blob)
    elsif vid
      includes(artifact_video_attachment: :blob)
    end
  }

  enum action: {
    'Display Message': 0,
    'Display Flyer': 1,
    'Call provider to schedule an Appointment': 2,
    'Create a appointment reminder in the app': 3,
    'Play Video': 4,
    'Launch External Website or Link': 5
  }

  enum artifact_type: {
    'document': 0,
    'video': 1,
    'web_url': 2
  }

  enum interaction: {
    'Message Box with OK button': 0,
    'Message Box with Yes No button': 1
  }

  def artifact_description_arr
    if artifact_type == 'video' && artifact_video.present?
      ["video.#{artifact_video.filename.extension}",  Rails.application.routes.url_helpers.rails_blob_url(artifact_video, only_path: true)]
    elsif artifact_type == 'document' && artifact_document.present?
      ["document.#{artifact_document.filename.extension}",
        Rails.application.routes.url_helpers.rails_blob_url(artifact_document, only_path: true)]
    else
      [artifact_url, artifact_url]
    end
  end

  def set_artifact_type_val
    if action === 'Display Flyer'
      self.artifact_type = 'document'
    elsif action === 'Play Video'
      self.artifact_type = 'video'
    elsif action === 'Launch External Website or Link'
      self.artifact_type = 'web_url'
    end
  end
end
