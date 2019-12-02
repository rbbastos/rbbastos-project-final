# frozen_string_literal: true

class ProvincesController < ApplicationController
  def index
    @provinces = Province.order(:name)
  end
end
