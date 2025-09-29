class CreateClients < ActiveRecord::Migration[7.2]
  def change
    create_table :clients do |t|
      t.string :full_name
      t.string :email
      t.date :birthdate

      t.timestamps
    end
  end
end
