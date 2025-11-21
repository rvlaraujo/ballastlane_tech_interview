require 'rails_helper'

RSpec.describe Author, type: :model do
  describe 'validations' do
    subject { build(:author) }
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).ignoring_case_sensitivity }
    it { should validate_length_of(:name).is_at_least(3).is_at_most(150) }
  end
end
