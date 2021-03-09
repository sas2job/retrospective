# frozen_string_literal: true

module Boards
  module Cards
    module Comments
      class BuildPermissions
        IDENTIFIERS_SCOPES = %w[comment].freeze

        include Dry::Monads[:result]
        attr_reader :comment, :user

        def initialize(comment, user)
          @comment = comment
          @user = user
        end

        def call(identifiers_scope:)
          unless IDENTIFIERS_SCOPES.include?(identifiers_scope.to_s)
            return Failure('Unknown permissions identifiers scope provided')
          end

          permissions_data = Permission.public_send(
            "#{identifiers_scope}_permissions"
          ).map do |permission|
            { permission_id: permission.id, user_id: user.id }
          end

          comment.comment_permissions_users.build(permissions_data)
          Success()
        end
      end
    end
  end
end
