class CreateCauses < ActiveRecord::Migration[5.2]
  def change
    create_table :causes do |t|
      t.string :name
      t.boolean :root_cause
      t.references :problem, foreign_key: true

      t.timestamps
    end
  end
end
