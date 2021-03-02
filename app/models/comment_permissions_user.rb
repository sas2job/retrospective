# frozen_string_literal: true

class CommentPermissionsUser < ApplicationRecord
  belongs_to :user
  belongs_to :permission
  belongs_to :comment

  validates_uniqueness_of :permission_id, scope: %i[user_id comment_id]
end
