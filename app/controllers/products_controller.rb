# frozen_string_literal: true

class ProductsController < ApplicationController
  before_action :initialize_session
  before_action :increment_visit_count, only: %i[index show]
  before_action :load_cart

  def index
    @products = Product.order(:name).page(params[:page])
    # When a user submits the form, a new line_item will be instantiated inside of current_order, so it will be available to the create route in line_Items_controller.rb.
    @line_item = current_order.line_items.new
  end

  def show
    @product = Product.find(params[:id])
  end

  # GET /products/search_results
  # convention that search result should be shareable like a link. IF you submit with a POST you cant bookmark that, IF you submit GET you can bookmark that
  def search_results
    @query = params[:query].to_s
    puts @query
    @id = params[:category].to_s
    if params[:category].to_s == ''
      @products = Product.where('name LIKE ?', "%#{@query}%")
    else
      @products = Product.where('products.name LIKE ?', "%#{@query}%").joins(:category).where('categories.id == ?', @id.to_s)
    end
    # <%= select_tag :category, options_for_select(['All', 'Computers & Tablets', 'Musical Instruments', 'Smart Home & Car Electronics', 'TV & Home Theatre', 'Video Games & Movies']) %>
  end

  def add_to_cart
    id = params[:id].to_i
    quantity = params[:quantity].to_i
    # add id unless id is already in array
    session[:cart] << id unless session[:cart].include?(id)
    # session[:key] = value unless session[:key].exist? (unless to update if exist)
    # redirect_to root_path
    redirect_back(fallback_location: root_path)
  end

  def remove_from_cart
    id = params[:id].to_i
    session[:cart].delete(id)
    redirect_back(fallback_location: root_path)
  end

  def shopping_cart; end

  private

  def initialize_session
    session[:cart] ||= []
  end

  def increment_visit_count; end

  def load_cart
    @cart2 = Product.find(session[:cart]) # if find will return an array of products
  end
end
