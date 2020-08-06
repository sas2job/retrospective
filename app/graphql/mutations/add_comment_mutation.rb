# frozen_string_literal: true

module Mutations
  class AddCommentMutation < Mutations::BaseMutation
    argument :attributes, Types::CommentAttributes, required: true

    field :comment, Types::CommentType, null: true

    # rubocop:disable Metrics/MethodLength
    def resolve(attributes:)
      params = attributes.to_h
      comment = Comment.new(params.merge(author: context[:current_user]))
      authorize! comment, to: :create?, context: { user: context[:current_user] }

      if comment.save
        card = comment.card
        RetrospectiveSchema.subscriptions.trigger('card_updated',
                                                  { board_slug: card.board.slug }, card)
        { comment: comment }
      else
        { errors: { full_messages: comment.errors.full_messages } }
      end
    end
    # rubocop:enable Metrics/MethodLength
  end
end
