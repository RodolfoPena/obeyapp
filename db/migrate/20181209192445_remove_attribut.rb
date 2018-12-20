class RemoveAttribut < ActiveRecord::Migration[5.2]
  def change
    remove_column :commitments, :assigned_commitments
  end
end
