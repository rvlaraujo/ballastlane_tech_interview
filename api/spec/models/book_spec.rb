require 'rails_helper'

RSpec.describe Book, type: :model do
  describe 'validations' do
    subject { build(:book) }
    it { should validate_presence_of(:title) }
    it { should validate_uniqueness_of(:isbn).ignoring_case_sensitivity }
    it { should validate_length_of(:title).is_at_least(3).is_at_most(150) }
    it { should validate_length_of(:isbn).is_equal_to(13) }
  end

  describe 'relations' do
    subject { create(:book) }
     it { should belong_to(:author) }
     it { should belong_to(:genre) }
  end
end
