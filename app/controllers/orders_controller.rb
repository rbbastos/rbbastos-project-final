# frozen_string_literal: true

class OrdersController < ApplicationController
  def index
    @orders = Order.order(:name)
  end

  def show
    @order = Order.find(params[:id])
  end

  def review_order
    if session[:order_id].nil?
      redirect_to root_path
    else
      @order = current_order
      # Need some adjustment to include address
      assign_atr(@order).save
    end
  end

  def order_final
    if session[:order_id].nil?
      redirect_to root_path
    else
      @order = current_order

      @session = Stripe::Checkout::Session.create(
        payment_method_types: ['card'],
        line_items: [
          {
            name: 'TESTE',
            amount: 500,
            currency: 'cad',
            quantity: 2
          },
          {
            name: 'PST',
            description: 'Manitoba Provincial Sales Tax',
            amount: (500 * 7 / 100.0).round.to_i,
            currency: 'cad',
            quantity: 1
          },
          {
            name: 'GST',
            description: 'Federal Goods and Services Tax',
            amount: (500 * 5 / 100.0).round.to_i,
            currency: 'cad',
            quantity: 1
          }
        ],
        success_url: order_final_url + '?session_id={CHECKOUT_SESSION_ID}',
        cancel_url: checkout_cancel_url
      )

      # respond_to do |format|
      #   format.js # renders create.js.erb
      # end

      @order.created_at = Time.now
      @order.save
      session[:order_id] = nil
    end
  end

  private

  def assign_atr(order)
    @cust_id = session[:cust_id]
    @cust = Customer.find(@cust_id)
    order.assign_attributes(
      customer_id: @cust_id,
      pstTimeOfPurchase: @cust.province.pstTax,
      gstTimeOfPurchase: @cust.province.gstTax
    )
    order
  end
end
