# frozen_string_literal: true

class CreateCardPermissionsUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :card_permissions_users do |t|
      t.belongs_to :user
      t.belongs_to :permission
      t.belongs_to :card

      t.index %i[permission_id user_id card_id],
              unique: true,
              name: 'index_card_permissions_users_on_user_card_permission'

      t.timestamps
    end
  end
end
