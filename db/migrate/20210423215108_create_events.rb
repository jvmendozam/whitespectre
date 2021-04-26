class CreateEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :events do |t|
      t.date :start_at
      t.date :end_at
      t.integer :duration
      t.string :name
      t.string :location
      t.text :description
      t.integer :status
      t.datetime :deleted_at
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
