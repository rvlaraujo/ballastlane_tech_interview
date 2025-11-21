class Book < ApplicationRecord
  belongs_to :genre
  belongs_to :author

  validates :title, presence: true, length: { minimum:3, maximum:150 }
  # isbn13 => 13 digits, the prefix must be 978 or 979
  validates :isbn, presence: true, length: { is: 13 }, uniqueness: true
  validates :total_copies, presence: true, length: { minimum:1 }
end
