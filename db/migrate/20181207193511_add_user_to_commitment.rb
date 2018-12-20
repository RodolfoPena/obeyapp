class AddUserToCommitment < ActiveRecord::Migration[5.2]
  def change
    add_reference :commitments, :user, foreign_key: true
  end
end
