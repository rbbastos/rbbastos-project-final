# frozen_string_literal: true

class Payment < ApplicationRecord
  belongs_to :order
  validates :amount, :date, presence: true
  validates :amount, numericality: { only_decimal: true }
  # actual association do not return all payments by customer
end
