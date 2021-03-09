# frozen_string_literal: true

class CreateCommentPermissionsUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :comment_permissions_users do |t|
      t.belongs_to :user
      t.belongs_to :permission
      t.belongs_to :comment

      t.index %i[permission_id user_id comment_id],
              unique: true,
              name: 'index_comment_permissions_users_on_user_card_permission'

      t.timestamps
    end
  end
end
