class AddResponsibleToCommitment < ActiveRecord::Migration[5.2]
  def change
    add_reference :commitments, :responsible
  end
end
