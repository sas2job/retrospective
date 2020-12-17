import React, {useState} from 'react';
import PrevActionItemColumn from './prev-action-item-column/prev-action-item-column';
import CardColumn from './card-column/card-column';
import ActionItemColumn from './action-item-column/action-item-column';
import BoardSlugContext from '../utils/board_slug_context';
import UserContext from '../utils/user-context';
import Provider from './provider/provider';

const CardTable = ({
  actionItems,
  cardsByType,
  creators,
  initPrevItems,
  user,
  users
}) => {
  const [columnClass, setColumnClass] = useState(
    'column board-column light-gray'
  );

  const [displayPreviousItems, setDisplayPreviousItems] = useState(
    initPrevItems.length > 0
  );

  const previousActionsEmptyHandler = () => {
    setDisplayPreviousItems(false);
    setColumnClass('column is-one-fourth');
  };

  const generateColumns = (cardTypePairs) => {
    const content = [];
    for (const [columnName, cards] of Object.entries(cardTypePairs)) {
      content.push(
        <div key={`${columnName}_column`} className={columnClass}>
          <CardColumn key={columnName} kind={columnName} initCards={cards} />
        </div>
      );
    }

    return content;
  };

  user.isCreator = creators.includes(user.id);
  return (
    <Provider>
      <BoardSlugContext.Provider value={window.location.pathname.split('/')[2]}>
        <UserContext.Provider value={user}>
          <div className="board-columns">
            {displayPreviousItems && (
              <div className={columnClass}>
                <PrevActionItemColumn
                  handleEmpty={previousActionsEmptyHandler}
                  initItems={initPrevItems || []}
                  users={users}
                />
              </div>
            )}

            {generateColumns(cardsByType)}

            <div className={columnClass}>
              <ActionItemColumn initItems={actionItems || []} users={users} />
            </div>
          </div>
        </UserContext.Provider>
      </BoardSlugContext.Provider>
    </Provider>
  );
};

export default CardTable;
