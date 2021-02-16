# frozen_string_literal: true

module Boards
  class SaveCardToBoard
    include Dry::Monads[:result]
    attr_reader :board, :user, :card

    def initialize(board, user, card)
      @board = board
      @user = user
      @card = card
    end

    def call
      card.save

      Boards::BuildPermissions.new(card, user).call(identifiers_scope: 'author')

      board.save
      Success()
    rescue StandardError => e
      Failure(e)
    end
  end
end
