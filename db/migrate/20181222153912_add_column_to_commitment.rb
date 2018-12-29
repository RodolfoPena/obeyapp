class AddColumnToCommitment < ActiveRecord::Migration[5.2]
  def change
    add_column :commitments, :closed_in_term, :boolean
  end
end
