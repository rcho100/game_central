class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :name
      t.string :genre
      t.string :system
      t.text :reason

      t.timestamps null: false
    end
  end
end