# frozen_string_literal: true

class DealsController < ApplicationController
  def show
    @deal = Deal.find(params[:id])
  end
end
