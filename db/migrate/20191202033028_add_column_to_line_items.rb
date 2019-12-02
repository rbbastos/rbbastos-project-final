# frozen_string_literal: true

class AddColumnToLineItems < ActiveRecord::Migration[6.0]
  def change
    add_column :line_items, :total_price, :float
  end
end
