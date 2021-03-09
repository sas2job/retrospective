# frozen_string_literal: true

module Mutations
  class AddCommentMutation < Mutations::BaseMutation
    argument :attributes, Types::CommentAttributes, required: true

    field :comment, Types::CommentType, null: true

    # rubocop:disable Metrics/MethodLength
    # rubocop:disable Metrics/AbcSize
    def resolve(attributes:)
      params = attributes.to_h
      card = Card.find(params[:card_id])
      authorize! card.board, to: :create_comments?, context: { user: context[:current_user] }

      result = Boards::Cards::Comments::Create.new(current_user).call(comment_params(params))

      if result.success?
        comment = result.value!
        card = comment.card
        RetrospectiveSchema.subscriptions.trigger('card_updated',
                                                  { board_slug: card.board.slug }, card)
        { comment: comment }
      else
        { errors: { full_messages: result.failure.message } }
      end
    end
    # rubocop:enable Metrics/MethodLength
    # rubocop:enable Metrics/AbcSize

    def comment_params(params)
      params.merge(author: context[:current_user])
    end
  end
end
