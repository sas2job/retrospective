# frozen_string_literal: true

module Mutations
  class AddCardMutation < Mutations::BaseMutation
    argument :attributes, Types::CardAttributes, required: true

    field :card, Types::CardType, null: true

    # rubocop:disable Metrics/MethodLength
    def resolve(attributes:)
      params = attributes.to_h
      board = Board.find_by!(slug: params.delete(:board_slug))
      card = Card.new(card_params(params, board))
      authorize! card, to: :create?, context: { user: context[:current_user], board: board }

      result = Boards::SaveCardToBoard.new(board, current_user, card).call

      if result.success?
        RetrospectiveSchema.subscriptions.trigger('card_added', { board_slug: board.slug }, card)
        { card: card }
      else
        { errors: { full_messages: card.errors.full_messages } }
      end
    end
    # rubocop:enable Metrics/MethodLength

    def card_params(params, board)
      params.merge(board: board, author: context[:current_user])
    end
  end
end
