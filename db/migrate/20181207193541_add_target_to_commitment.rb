class AddTargetToCommitment < ActiveRecord::Migration[5.2]
  def change
    add_reference :commitments, :target, foreign_key: true
  end
end
