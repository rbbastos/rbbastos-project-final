# frozen_string_literal: true

class CategoriesController < ApplicationController
  def index
    @categories = Category.order(:name)
    # @line_item = current_order.line_items.new
  end

  def show
    @category = Category.find(params[:id])
  end
end
