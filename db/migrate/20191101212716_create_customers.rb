class CreateCustomers < ActiveRecord::Migration[6.0]
  def change
    create_table :customers do |t|
      t.string :firstName
      t.string :lastName
      t.string :streetAddress
      t.string :city
      t.string :country
      t.string :postalCode
      t.string :phone
      t.integer :stripeId
      t.references :province, null: false, foreign_key: true

      t.timestamps
    end
  end
end
