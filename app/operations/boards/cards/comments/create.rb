# frozen_string_literal: true

module Boards
  module Cards
    module Comments
      class Create
        include Dry::Monads[:result]
        attr_reader :user

        def initialize(user)
          @user = user
        end

        def call(comment_params)
          comment = Comment.new(comment_params)

          comment.transaction do
            BuildPermissions.new(comment, user).call(identifiers_scope: 'comment')
            comment.save!
          end

          Success(comment)
        rescue StandardError => e
          Failure(e)
        end
      end
    end
  end
end
