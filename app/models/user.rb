class User < ApplicationRecord
  # model association
  has_many :events, dependent: :destroy

  # validations
  validates_presence_of :name, :last_name
end
