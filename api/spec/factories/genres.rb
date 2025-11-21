FactoryBot.define do
  factory :genre do
    sequence(:name) { |n| %w[Scify Action Drama Other].sample + "Genre #{n}" }
  end
end
