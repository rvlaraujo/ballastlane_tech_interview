require_relative '../support/helpers/generate_isbn'

FactoryBot.define do
  factory :book do
    sequence(:title) { |n| "Book #{n}" }
    isbn { Helpers::GenerateIsbn.random_isbn_13 }
    total_copies { rand(1..10) }

    genre
    author
  end
end
