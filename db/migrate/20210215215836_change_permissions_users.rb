# frozen_string_literal: true

class ChangePermissionsUsers < ActiveRecord::Migration[6.1]
  def change
    rename_table :permissions_users, :board_permissions_users
  end
end
