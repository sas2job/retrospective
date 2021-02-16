# frozen_string_literal: true

module Boards
  class BuildPermissions
    IDENTIFIERS_SCOPES = %w[creator member author].freeze

    include Dry::Monads[:result]
    attr_reader :resource, :user

    def initialize(resource, user)
      @resource = resource
      @user = user
    end

    # rubocop:disable Metrics/MethodLength
    def call(identifiers_scope:)
      unless IDENTIFIERS_SCOPES.include?(identifiers_scope.to_s)
        return Failure('Unknown permissions identifiers scope provided')
      end

      permissions_data = Permission.public_send(
        "#{identifiers_scope}_permissions"
      ).map do |permission|
        { permission_id: permission.id, user_id: user.id }
      end

      resource_name = resource.class.to_s.downcase
      resource.public_send("#{resource_name}_permissions_users").build(permissions_data)
      Success()
    end
    # rubocop:enable Metrics/MethodLength
  end
end
