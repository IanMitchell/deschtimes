class ChangeDefaultMemberAdminValue < ActiveRecord::Migration[6.1]
  def change
    change_column_default :members, :admin, false
  end
end
