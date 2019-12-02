# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # We've also added helper_method :current_order, making this method available to our controllers and views.
  helper_method :current_order, :products_in_cart_count
  add_flash_types :info, :error, :warning

  def current_order
    # When current_order is called, we'll check if there's an order_id associated with the session and then find that order. If there isn't, we'll create a new order.
    if session[:order_id] # && Order.where(id: session[:order_id]).count.positive?
      Order.find(session[:order_id])
    else
      Order.new
    end
  end

  def products_in_cart_count
    if Order.where(id: session[:order_id]).count.positive?
      Order.where(id: session[:order_id]).first.line_items.sum(:quantity)
    else
      0
    end
  end
end
