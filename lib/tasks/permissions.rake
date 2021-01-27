# frozen_string_literal: true

namespace :permissions do
  desc 'update creators and members with missing permissions'
  task membership_permissions: :environment do
    creator_memberships = Membership.creator
    puts "#{creator_memberships.count} creator memberships found"

    creator_memberships.find_each.with_index(1) do |membership, i|
      puts "Processing #{i}/#{creator_memberships.count}" if (i % 10).zero?

      ids = PermissionsUser.where(user: membership.user, board: membership.board)
                           .pluck(:permission_id)
      permissions = Permission.creator_permissions.where.not(id: ids)

      create_permissions_users(permissions, membership)
    end

    member_memberships = Membership.member
    puts "#{member_memberships.count} member memberships found"

    member_memberships.find_each.with_index(1) do |membership, i|
      puts "Processing #{i}/#{member_memberships.count}" if (i % 10).zero?

      ids = PermissionsUser.where(user: membership.user, board: membership.board)
                           .pluck(:permission_id)
      permissions = Permission.member_permissions.where.not(id: ids)

      create_permissions_users(permissions, membership)
    end; 'ok'
  end

  def create_permissions_users(permissions, membership)
    permissions.each do |permission|
      PermissionsUser.create!(user: membership.user,
                              permission: permission,
                              board: membership.board)
    rescue StandardError => e
      puts "Failed to add #{permission.identifier} for #{membership.user.email}: #{e.message}"
    end; 'ok'
  end
end
