import React from 'react';
import {InviteBlock} from './invite-block';
import {Provider} from './provider';
import BoardSlugContext from '../utils/board_slug_context';

const InviteBlockContainer = () => {
  return (
    <Provider>
      <BoardSlugContext.Provider value={window.location.pathname.split('/')[2]}>
        <InviteBlock />
      </BoardSlugContext.Provider>
    </Provider>
  );
};

export default InviteBlockContainer;
