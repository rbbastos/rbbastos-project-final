# frozen_string_literal: true

class Customer < ApplicationRecord
  belongs_to :province
  has_many :orders
  validates :firstName, :lastName, presence: true
  # validates :stripeId, numericality: { only_integer: true }
  # actual association do not return all payment by customer
end
