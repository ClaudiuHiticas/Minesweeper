class CreateMine < ActiveRecord::Migration[6.1]
  def change
    create_table :mines do |t|
      t.integer :x
      t.integer :y
      t.references :board, null: false, foreign_key: true

      t.timestamps
    end
  end
end
