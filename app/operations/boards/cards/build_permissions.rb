# frozen_string_literal: true

module Boards
  module Cards
    class BuildPermissions
      IDENTIFIERS_SCOPES = %w[author].freeze

      include Dry::Monads[:result]
      attr_reader :card, :user

      def initialize(card, user)
        @card = card
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

        card.card_permissions_users.build(permissions_data)
        Success()
      end
    end
  end
end
