# frozen_string_literal: true

class Product < ApplicationRecord
  belongs_to :category
  belongs_to :deal
  has_many :line_items
  has_many :orders, through: :line_items, source: :order
  has_one_attached :image
  validates :name, :manufacturer, :sellPrice, presence: true
  validates :sellPrice, numericality: { only_decimal: true }
  paginates_per 15
end
