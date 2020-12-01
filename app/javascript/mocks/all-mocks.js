// Here is described what we need to change in initial data

export const USER = {
  id: '1',
  email: 'tu1@mail.com',
  firstName: 'tu1@mail',
  lastName: 'ivanoff',
  nickname: 'ivan',
  avatar: null || `11.png`,
  avatarCompressed: null || `11.png`,
  permissions: []
};

export const ACTION_ITEM = {
  id: '7',
  body: `text`,
  timesMoved: 1,
  status: `pending`,
  assignee: USER
};

export const CARD = {
  type: `mad`,
  author: USER,
  body: 'some text',
  comments: [
    {
      author: USER,
      cardId: '327',
      content: '1',
      id: '36',
      likes: 0
    }
  ],
  id: '89',
  kind: 'sad',
  likes: 0
};

export const PREVIOUS_ITEMS = [
  {
    id: 111,
    body: `text`,
    timesMoved: 1,
    status: `pending`,
    assignee: USER
  },
  {
    id: 121,
    body: `text`,
    timesMoved: 1,
    status: `pending`,
    assignee: USER
  }
];

// In users shouldn't be permissions

export const USERS = [
  {
    id: '3',
    email: 'tu2@mail.com',
    firstName: 'tu1@mail',
    lastName: 'ivanoff',
    nickname: 'ivan',
    avatar: null || `11.png`,
    avatarCompressed: null || `11.png`
  }
];
