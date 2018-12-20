class AddResponsibleToTarget < ActiveRecord::Migration[5.2]
  def change
    add_reference :targets, :responsible
  end
end
