# frozen_string_literal: true

class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string :name
      t.string :manufacturer
      t.text :description
      t.decimal :sellPrice
      t.references :category, null: false, foreign_key: true
      t.references :deal, null: false, foreign_key: true
      t.timestamps
    end
  end
end
