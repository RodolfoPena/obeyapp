class RemoveStatusFromCommitment < ActiveRecord::Migration[5.2]
  def change
    change_column :commitments, :status, :integer, using: 'status::integer'
  end
end
