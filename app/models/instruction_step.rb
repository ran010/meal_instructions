class InstructionStep < ApplicationRecord
  belongs_to :meal

  validates :position, presence: true
  validates :description, presence: true
end

