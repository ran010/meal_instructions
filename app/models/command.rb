class Command < ApplicationRecord
  belongs_to :user
  has_many_attached :attachments, dependent: :destroy
  validate :validate_attachment_filetypes
  private

  def validate_attachment_filetypes
    return unless attachments.attached?

    attachments.each do |attachment|
      puts attachment.content_type
      next if attachment.content_type.in?(%w[audio/x-wav audio/ogg audio/webm])

      errors.add(:attachments, 'must be a  OGG, or WAV file')
    end
  end
end
