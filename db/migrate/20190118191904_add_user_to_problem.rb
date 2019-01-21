class AddUserToProblem < ActiveRecord::Migration[5.2]
  def change
    add_reference :problems, :user, foreign_key: true
  end
end
