class InstructionTemplateStep < ApplicationRecord
  belongs_to :meal_template

  validates :position, presence: true
  validates :description, presence: true
end

