# frozen_string_literal: true

module Boards
  module Cards
    class Create
      include Dry::Monads[:result]
      attr_reader :user, :params

      def initialize(user, card_params)
        @user = user
        @params = card_params
      end

      def call
        card = Card.new(params)

        card.transaction do
          Boards::BuildPermissions.new(card, user).call(identifiers_scope: 'author')
          card.save!
        end

        Success(card)
      rescue StandardError => e
        Failure(e)
      end
    end
  end
end
