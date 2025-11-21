FactoryBot.define do
  factory :gender do
    sequence(:name) { |n| "Gender #{n}" }
  end
end
