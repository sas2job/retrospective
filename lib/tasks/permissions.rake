# frozen_string_literal: true

namespace :permissions do
  desc 'update creators and members with missing permissions'
  task create_missing_for_boards: :environment do
    Membership.creator.find_each do |membership|
      # rubocop:disable Metrics/LineLength
      permission_ids = Permission.creator_permissions.where.not(id: BoardPermissionsUser.select(:permission_id)
        .where(user: membership.user, board: membership.board)).ids
      # rubocop:enable Metrics/LineLength

      create_board_permissions_users(permission_ids, membership) unless permission_ids.empty?
    end

    Membership.member.find_each do |membership|
      # rubocop:disable Metrics/LineLength
      permission_ids = Permission.member_permissions.where.not(id: BoardPermissionsUser.select(:permission_id)
        .where(user: membership.user, board: membership.board)).ids
      # rubocop:enable Metrics/LineLength

      create_board_permissions_users(permission_ids, membership) unless permission_ids.empty?
    end
  end

  # rubocop:disable Metrics/MethodLength
  def create_board_permissions_users(permission_ids, membership)
    unless Rails.env.test?
      puts "#{permission_ids.count} missing permissions for Membership-#{membership.id} found"
    end
    counter = 0

    permission_ids.each do |permission_id|
      BoardPermissionsUser.create!(user: membership.user,
                                   permission_id: permission_id,
                                   board: membership.board)
      counter += 1

    rescue StandardError => e
      puts "Failed to add #{permission.identifier} for#{membership.user.email}: #{e.message}"
    end

    puts "#{counter} permissions successfully updated" unless Rails.env.test?
  end
  # rubocop:enable Metrics/MethodLength

  desc 'update creators and members with missing permissions'
  task create_missing_for_cards: :environment do
    counter = 0

    Card.find_each do |card|
      Permission.author_permissions.each do |permission|
        permissions_users_data = { card: card, permission: permission, user: card.author }
        next if CardPermissionsUser.exists?(permissions_users_data)

        CardPermissionsUser.create!(permissions_users_data)
        counter += 1

      rescue StandardError => e
        puts "Failed to add #{permission.identifier} for#{card.author.email}: #{e.message}"
      end
    end

    if !Rails.env.test? && counter.positive?
      puts "#{counter} cards permissions successfully updated"
    end
  end
end
