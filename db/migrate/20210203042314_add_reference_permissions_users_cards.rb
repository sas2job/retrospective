# frozen_string_literal: true

class AddReferencePermissionsUsersCards < ActiveRecord::Migration[6.1]
  def change
    add_reference :permissions_users, :card, foreign_key: true

    remove_index :permissions_users, %i[permission_id user_id board_id],
                 name: 'index_permissions_users_on_user_board_permission'
    add_index :permissions_users, %i[permission_id user_id board_id card_id],
              unique: true,
              name: 'index_permissions_users_on_user_board_permission_card'
  end
end
