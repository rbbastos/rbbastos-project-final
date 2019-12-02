# frozen_string_literal: true

class AddColumnToOrders < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :subtotal, :float
    add_column :orders, :total, :float
  end
end
