class PaymentsController < ApplicationController
  def index
    @payments = Payment.order(:name)
  end

  def show
    @payment = Payment.find(params[:id])
  end
end
