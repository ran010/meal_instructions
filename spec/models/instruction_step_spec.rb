require 'rails_helper'

RSpec.describe InstructionStep, type: :model do
  describe "associations" do
    it { should belong_to(:meal)}
  end
  describe "validations" do
    it { should validate_presence_of(:position) }
    it { should validate_presence_of(:description) }
  end
end
