# frozen_string_literal: true

class Deal < ApplicationRecord
  has_many :products
  validates :name, presence: true
end
