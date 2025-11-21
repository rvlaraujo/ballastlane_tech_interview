module Helpers
  module GenerateIsbn
    def self.random_isbn_13
      # common ISBN13 prefixes
      prefix = ["978", "979"].sample

      random_digits = 10.times.map { rand(10) }.join

      prefix + random_digits
    end
  end
end