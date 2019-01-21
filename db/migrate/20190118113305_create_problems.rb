class CreateProblems < ActiveRecord::Migration[5.2]
  def change
    create_table :problems do |t|
      t.string :title
      t.string :type
      t.string :status
      t.date :status_update
      t.references :target, foreign_key: true

      t.timestamps
    end
  end
end
