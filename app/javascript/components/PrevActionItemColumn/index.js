import React, {useState, useContext, useEffect} from 'react';
import ActionItem from '../ActionItem';
import {
  actionItemMovedSubscription,
  actionItemUpdatedSubscription
} from './operations.gql';
import {useSubscription} from '@apollo/react-hooks';
import UserContext from '../../utils/user-context';
import BoardSlugContext from '../../utils/board_slug_context';

const PreviousActionItemColumn = (props) => {
  const {creators, handleEmpty, initItems} = props;

  const [actionItems, setActionItems] = useState(initItems);
  const [skip, setSkip] = useState(true); // Workaround for https://github.com/apollographql/react-apollo/issues/3802

  const currentUser = useContext(UserContext);
  const boardSlug = useContext(BoardSlugContext);

  useSubscription(actionItemMovedSubscription, {
    skip,
    onSubscriptionData: (options) => {
      const {data} = options.subscriptionData;
      const {actionItemMoved} = data;
      if (actionItemMoved) {
        setActionItems((oldItems) => {
          const newItems = oldItems.filter(
            (element) => element.id !== actionItemMoved.id
          );
          if (newItems.length === 0) {
            handleEmpty();
          }

          return newItems;
        });
      }
    },
    variables: {boardSlug}
  });

  useSubscription(actionItemUpdatedSubscription, {
    skip,
    onSubscriptionData: (options) => {
      const {data} = options.subscriptionData;
      const {actionItemUpdated} = data;
      if (actionItemUpdated) {
        setActionItems((oldItems) => {
          const cardIdIndex = oldItems.findIndex(
            (element) => element.id === actionItemUpdated.id
          );
          if (cardIdIndex >= 0) {
            return [
              ...oldItems.slice(0, cardIdIndex),
              actionItemUpdated,
              ...oldItems.slice(cardIdIndex + 1)
            ];
          }

          return oldItems;
        });
      }
    },
    variables: {boardSlug}
  });

  useEffect(() => {
    setSkip(false);
  }, []);

  // Restart here

  const isAccssible = creators.includes(currentUser.id);
  return (
    <>
      <h2 className="board-subtitle">PREVIOUS BOARD</h2>
      {actionItems.map((item) => {
        return (
          <ActionItem
            key={item.id}
            id={item.id}
            body={item.body}
            status={item.status}
            times_moved={item.times_moved}
            movable={isAccssible && item.status === 'pending'}
            transitionable={{
              can_close: isAccssible && item.status === 'pending',
              can_complete: isAccssible && item.status === 'pending',
              can_reopen: isAccssible && item.status !== 'pending'
            }}
            assignee={item.assignee?.nickname}
            firstName={item.assignee?.first_name}
            lastName={item.assignee?.last_name}
            avatar={item.assignee_avatar_url}
          />
        );
      })}
    </>
  );
};

export default PreviousActionItemColumn;
