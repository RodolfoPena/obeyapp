class CreateCommitments < ActiveRecord::Migration[5.2]
  def change
    create_table :commitments do |t|
      t.string :action
      t.text :conditions_of_satisfaction
      t.date :start_date
      t.date :due_date
      t.date :renegotiation_date
      t.date :closing_date
      t.boolean :critical
      t.boolean :deliverable

      t.timestamps
    end
  end
end
