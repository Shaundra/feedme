class Tag < ApplicationRecord
  belongs_to :user
  has_many :entry_tags
  has_many :entries, through: :entry_tags
end
