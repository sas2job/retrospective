# frozen_string_literal: true

module Mutations
  class CloseActionItemMutation < Mutations::BaseMutation
    argument :id, ID, required: true
    argument :board_slug, String, required: true

    field :action_item, Types::ActionItemType, null: true

    # rubocop:disable Metrics/MethodLength
    def resolve(id:, board_slug:)
      action_item = ActionItem.find(id)
      board = Board.find_by!(slug: board_slug)
      authorize! action_item, to: :close?,
                              context: { user: context[:current_user],
                                         board: board }

      if action_item.close!
        RetrospectiveSchema.subscriptions.trigger('action_item_updated', { board_slug: board.slug },
                                                  action_item)
        { action_item: action_item }
      else
        { errors: { full_messages: action_item.errors.full_messages } }
      end
    end
    # rubocop:enable Metrics/MethodLength
  end
end
