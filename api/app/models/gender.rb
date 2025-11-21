class Gender < ApplicationRecord
  normalizes :name, with: ->(name) { name.strip.upcase }
  
  validates :name, presence: true, uniqueness: true, length: { minimum: 3, maximum: 50 }
end
