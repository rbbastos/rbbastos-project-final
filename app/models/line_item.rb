# frozen_string_literal: true

class LineItem < ApplicationRecord
  belongs_to :product
  belongs_to :order
  # validates :quantity, :unit_price, presence: true
  # validates :quantity, :unit_price, numericality: { only_decimal: true }

  before_save :set_unit_price
  before_save :set_total_price

  def unit_price
    if persisted?
      self[:unit_price]
    else
      product.sellPrice
    end
  end

  def total_price
    unit_price.to_f * quantity.to_i
  end

  private

  def set_unit_price
    self[:unit_price] = unit_price
  end

  def set_total_price
    self[:total_price] = quantity * set_unit_price
  end
end
