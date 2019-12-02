# frozen_string_literal: true

class Province < ApplicationRecord
  has_many :customers
  has_many :orders, through: :customers
  validates :name, :gstTax, :pstTax, presence: true
  validates :gstTax, :pstTax, numericality: { only_decimal: true }
end
