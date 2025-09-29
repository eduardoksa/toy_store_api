class CreateSales < ActiveRecord::Migration[7.2]
  def change
    create_table :sales do |t|
      t.references :client, null: false, foreign_key: true
      t.decimal :value, precision: 10, scale: 2
      t.date :sold_at

      t.timestamps
    end
  end
end
