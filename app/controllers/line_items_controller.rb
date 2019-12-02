# frozen_string_literal: true

class LineItemsController < ApplicationController
  # before_action :initialize_session
  after_action :update_session, only: [:create]
  before_action :initialize_session

  def index
    @line_items = LineItem.order(:name)
  end

  def create
    # We start by calling current_order. Because we haven't set session[:order_id] yet, our current_order method in application_controller.rb will set @order = Order.new.
    @order = current_order
    product_in_cart?(@order) ? update_product_quantity(@order) : add_product_to_order(@order)
    # if @order
    #   flash[:success] = "Order = current_order #{@order} (line_item_controller)!"
    # else
    #   flash[:error] = 'Order NOT = current_order (line_item_controller).'
    # end

    # We add the order_item to the order and then save the order.
    # @item = @order.line_items.new(item_params)
    # if @item
    #   flash[:success] = "Item = @order.line_items.new(item_params) #{@item} (line_item_controller)!"
    # else
    #   flash[:error] = 'Item NOT = @order.line_items.new(item_params) (line_item_controller).'
    # end

    # assign_atr(@order).save
    # if @order.save
    #   flash[:success] = 'Order saved successfuly (line_item_controller)!'
    # else
    #   flash[:error] = "Order NOT saved (line_item_controller). #{@order.errors.messages}"
    # end
    # Finally, we set the value of session[:order_id] to our newly instantiated @order.id.
    # session[:order_id] = @order.id
    # redirect
  end

  def destroy
    @order = current_order
    @item = @order.line_items.find(params[:id])
    @item.destroy
    @order.save
    redirect_to cart_path
  end
  # def update
  #   @order = current_order
  #   @line_item = @order.line_items.find(params[:id])
  #   @line_item.update_attributes(item_params)
  #   @line_items = @order.line_items
  # end

  private

  def item_params
    params.require(:line_item).permit(:quantity, :product_id)
  end

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

  def product_in_cart?(order)
    order.line_items.where(product_id: item_params[:product_id]).count.positive?
  end

  def add_product_to_order(order)
    order.line_items.new(item_params)
    assign_atr(order).save
    flash[:success] = 'Product added in the shopping cart.'
    redirect_to products_path item_params[:product_id]
  end

  def update_product_quantity(order)
    @product = filter_product_by_id(order, item_params[:product_id])
    if params[:line_item][:update_cart]
      @product.quantity = item_params[:quantity]
    else
      @product.quantity += 1
    end
    @product.save
    @order.save
    flash[:success] = 'Cart updated successfuly!'
    redirect_to cart_path
  end

  def filter_product_by_id(order, product_id)
    order.line_items.where(product_id: product_id).first
  end

  def redirect
    if params[:line_book][:update_cart]
      flash[:success] = 'Cart updated successfuly!'
      redirect_to cart_path
    else
      flash[:success] = 'Product added in the shopping cart.'
      redirect_to products_path item_params[:product_id]
    end
  end

  def update_session
    session[:order_id] = @order.id
  end

  def initialize_session
    c = Customer.order('random()').first
    session[:cust_id] ||= c.id
  end
end
