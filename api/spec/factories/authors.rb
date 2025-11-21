FactoryBot.define do
  factory :author do
    sequence(:name) { |n| "Gender #{n}" }
  end
end
