# frozen_string_literal: true

module Boards
  class BuildPermissions
    IDENTIFIERS_SCOPES = %w[creator member author].freeze

    include Dry::Monads[:result]
    attr_reader :board, :user, :card

    def initialize(board, user, card: nil)
      @board = board
      @user = user
      @card = card
    end

    def call(identifiers_scope:)
      unless IDENTIFIERS_SCOPES.include?(identifiers_scope.to_s)
        return Failure('Unknown permissions identifiers scope provided')
      end

      permissions_data = Permission.public_send(
        "#{identifiers_scope}_permissions"
      ).map do |permission|
        { permission_id: permission.id, user_id: user.id, card_id: @card&.id }
      end

      board.permissions_users.build(permissions_data)
      Success()
    end
  end
end
