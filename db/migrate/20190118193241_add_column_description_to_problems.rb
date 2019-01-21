class AddColumnDescriptionToProblems < ActiveRecord::Migration[5.2]
  def change
    add_column :problems, :description, :string
  end
end
