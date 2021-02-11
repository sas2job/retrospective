# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create([
              { email: 'tu1@mail.com', password: '123456', nickname: 'tu1', provider: 'provider', uid: 'uid1', last_name: 'Sidorov', first_name: 'Ivan' },
              { email: 'tu2@mail.com', password: '123456', nickname: 'tu2', provider: 'provider', uid: 'uid2', last_name: 'Petrov', first_name: 'Petr' },
              { email: 'tu3@mail.com', password: '123456', nickname: 'tu3', provider: 'provider', uid: 'uid3', last_name: 'Ivanov', first_name: 'Andrey' },
              { email: 'tu4@mail.com', password: '123456', nickname: 'tu4', provider: 'provider', uid: 'uid4', last_name: 'Abramov', first_name: 'Dmitriy' },
              { email: 'tu5@mail.com', password: '123456', nickname: 'tu5', provider: 'provider', uid: 'uid5', last_name: 'Mokhov', first_name: 'Fedor' },
              { email: 'tu6@mail.com', password: '123456', nickname: 'tu6', provider: 'provider', uid: 'uid6', last_name: 'Sidorova', first_name: 'Marina' },
              { email: 'tu7@mail.com', password: '123456', nickname: 'tu7', provider: 'provider', uid: 'uid7', last_name: 'Petrova', first_name: 'Anna' },
              { email: 'tu8@mail.com', password: '123456', nickname: 'tu8', provider: 'provider', uid: 'uid8', last_name: 'Ivanova', first_name: 'Sveta' },
              { email: 'tu9@mail.com', password: '123456', nickname: 'tu9', provider: 'provider', uid: 'uid9', last_name: 'Mokhova', first_name: 'Lyubov' }
            ])

user1 = User.find_by(email: 'tu1@mail.com')
user2 = User.find_by(email: 'tu2@mail.com')
user3 = User.find_by(email: 'tu3@mail.com')
user4 = User.find_by(email: 'tu4@mail.com')
user5 = User.find_by(email: 'tu5@mail.com')
user6 = User.find_by(email: 'tu6@mail.com')
user7 = User.find_by(email: 'tu7@mail.com')
user8 = User.find_by(email: 'tu8@mail.com')
user9 = User.find_by(email: 'tu9@mail.com')

Team.create(name: 'Wolves', user_ids: [user1.id, user2.id, user3.id, user4.id, user5.id]) unless Team.where(name: 'Wolves').exists?
Team.create(name: 'Tigers', user_ids: [user1.id, user5.id]) unless Team.where(name: 'Tigers').exists?
Team.create(name: 'Eagles', user_ids: [user2.id, user3.id, user4.id]) unless Team.where(name: 'Eagles').exists?

Board.create(title: 'TestUser1_RetroBoard') unless Board.where(title: 'TestUser1_RetroBoard').exists?
Board.create(title: 'TestUser2_RetroBoard') unless Board.where(title: 'TestUser2_RetroBoard').exists?
Board.create(title: 'TestUser3_RetroBoard') unless Board.where(title: 'TestUser3_RetroBoard').exists?
Board.create(title: 'TestUser4_RetroBoard') unless Board.where(title: 'TestUser4_RetroBoard').exists?
Board.create(title: 'TestUser5_RetroBoard') unless Board.where(title: 'TestUser5_RetroBoard').exists?

board1 = Board.find_by(title: 'TestUser1_RetroBoard')
board2 = Board.find_by(title: 'TestUser2_RetroBoard')
board3 = Board.find_by(title: 'TestUser2_RetroBoard')
board4 = Board.find_by(title: 'TestUser2_RetroBoard')
board5 = Board.find_by(title: 'TestUser2_RetroBoard')

Membership.create([
                    { user_id: user1.id, board_id: board1.id, role: 'creator', ready: false },
                    { user_id: user2.id, board_id: board1.id, role: 'member', ready: false },
                    { user_id: user3.id, board_id: board1.id, role: 'member', ready: false },
                    { user_id: user4.id, board_id: board1.id, role: 'member', ready: false },
                    { user_id: user5.id, board_id: board1.id, role: 'member', ready: false },
                    { user_id: user6.id, board_id: board1.id, role: 'member', ready: false },
                    { user_id: user7.id, board_id: board1.id, role: 'member', ready: false },
                    { user_id: user8.id, board_id: board1.id, role: 'member', ready: false },
                    { user_id: user9.id, board_id: board1.id, role: 'member', ready: false },
                    { user_id: user2.id, board_id: board2.id, role: 'creator', ready: false },
                    { user_id: user2.id, board_id: board3.id, role: 'creator', ready: false },
                    { user_id: user2.id, board_id: board4.id, role: 'creator', ready: false },
                    { user_id: user2.id, board_id: board5.id, role: 'creator', ready: false }
                  ])

permissions_data = {
  view_private_board: 'User can view private board',
  create_cards: 'User can create cards on board',
  edit_board: 'User can edit board',
  update_board: 'User can update board',
  destroy_board: 'User can destroy board',
  continue_board: 'User can continue previous board',
  invite_members: 'User can invite members to board',
  get_suggestions: 'User can get tips with info',
  toggle_ready_status: 'User can toggle ready status of board membership',
  destroy_membership: 'User can destroy membership of board'
}

errors = []

(Permission::CREATOR_IDENTIFIERS | Permission::MEMBER_IDENTIFIERS).each do |identifier|
  next if Permission.exists?(identifier: identifier)

  begin
    Permission.create!(identifier: identifier, description: permissions_data[identifier.to_sym])
  rescue StandardError => e
    errors << { identifier => e.message }
  end
end
puts errors

Permission.creator_permissions.each do |permission|
  PermissionsUser.create([
                           { user_id: user1.id, permission_id: permission.id, board_id: board1.id },
                           { user_id: user2.id, permission_id: permission.id, board_id: board2.id },
                           { user_id: user2.id, permission_id: permission.id, board_id: board3.id },
                           { user_id: user2.id, permission_id: permission.id, board_id: board4.id },
                           { user_id: user2.id, permission_id: permission.id, board_id: board5.id }
                         ])
end

Permission.member_permissions.each do |permission|
  PermissionsUser.create([
                           { user_id: user2.id, permission_id: permission.id, board_id: board1.id },
                           { user_id: user3.id, permission_id: permission.id, board_id: board1.id },
                           { user_id: user4.id, permission_id: permission.id, board_id: board1.id },
                           { user_id: user5.id, permission_id: permission.id, board_id: board1.id },
                           { user_id: user6.id, permission_id: permission.id, board_id: board1.id },
                           { user_id: user7.id, permission_id: permission.id, board_id: board1.id },
                           { user_id: user8.id, permission_id: permission.id, board_id: board1.id },
                           { user_id: user9.id, permission_id: permission.id, board_id: board1.id }
                         ])
end

Card.create(kind: 'mad', body: 'user1 is very mad', author_id: user1.id, board_id: board1.id) unless Card.where(body: 'user1 is very mad').exists?
Card.create(kind: 'sad', body: 'user1 is very sad', author_id: user1.id, board_id: board1.id) unless Card.where(body: 'user1 is very sad').exists?
Card.create(kind: 'glad', body: 'user1 is very glad #1', author_id: user1.id, board_id: board1.id) unless Card.where(body: 'user1 is very glad #1').exists?
Card.create(kind: 'glad', body: 'user1 is very glad #2', author_id: user1.id, board_id: board1.id) unless Card.where(body: 'user1 is very glad #2').exists?
Card.create(kind: 'sad', body: 'user2 is very sad', author_id: user2.id, board_id: board1.id) unless Card.where(body: 'user2 is very sad').exists?
Card.create(kind: 'mad', body: 'user3 is very mad', author_id: user3.id, board_id: board1.id) unless Card.where(body: 'user3 is very mad').exists?
Card.create(kind: 'mad', body: 'user4 is very mad', author_id: user4.id, board_id: board1.id) unless Card.where(body: 'user4 is very mad').exists?
Card.create(kind: 'mad', body: 'user5 is very mad', author_id: user5.id, board_id: board1.id) unless Card.where(body: 'user5 is very mad').exists?

ActionItem.create(body: 'issue should be fixed', board_id: board1.id, author_id: user1.id) unless ActionItem.where(body: 'issue should be fixed', board_id: board1.id, author_id: user1.id).exists?
ActionItem.create(body: 'meetings should be held', board_id: board1.id, author_id: user1.id) unless ActionItem.where(body: 'meetings should be held', board_id: board1.id, author_id: user1.id).exists?
ActionItem.create(body: 'actions should be taken', board_id: board1.id, author_id: user1.id) unless ActionItem.where(body: 'actions should be taken', board_id: board1.id, author_id: user1.id).exists?

Rake::Task['permissions:create_missing'].invoke
