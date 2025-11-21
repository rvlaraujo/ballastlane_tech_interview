require 'rails_helper'

RSpec.describe Gender, type: :model do
  describe 'validations' do
    subject { build(:gender) }
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).ignoring_case_sensitivity }
    it { should validate_length_of(:name).is_at_most(50) }
  end
end
