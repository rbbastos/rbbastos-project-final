class CreateProvinces < ActiveRecord::Migration[6.0]
  def change
    create_table :provinces do |t|
      t.string :name
      t.decimal :gstTax
      t.decimal :pstTax

      t.timestamps
    end
  end
end
