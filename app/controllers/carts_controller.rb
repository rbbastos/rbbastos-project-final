# frozen_string_literal: true

class CartsController < ApplicationController
  def show
    # Once again we access the current_order to determine the line_items for the customer's order.
    @line_items = current_order.line_items
    @line_item = current_order.line_items.new
    @cart_items = Product.find(session[:cart])
  end
end
