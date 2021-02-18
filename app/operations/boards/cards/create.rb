# frozen_string_literal: true

module Boards
  module Cards
    class Create
      include Dry::Monads[:result]

      def call(user, card_params)
        card = Card.new(card_params)

        card.transaction do
          BuildPermissions.new(card, user).call(identifiers_scope: 'author')
          card.save!
        end

        Success(card)
      rescue StandardError => e
        Failure(e)
      end
    end
  end
end
