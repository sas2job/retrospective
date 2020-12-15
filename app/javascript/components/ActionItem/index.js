import React, {useContext} from 'react';
import ActionItemBody from './ActionItemBody';
import ActionItemFooter from './ActionItemFooter';
import './ActionItem.css';
import UserContext from '../../utils/user-context';
import CardUser from '../CardColumn/Card/card-user/card-user';

const ActionItem = ({
  creators,
  id,
  body,
  status,
  times_moved,
  assignee,
  users,
  isPrevious
}) => {
  const pickColor = (cardStatus) => {
    switch (cardStatus) {
      case 'done':
        return 'green';
      case 'closed':
        return 'red';
      default:
        return null;
    }
  };

  const currentUser = useContext(UserContext);
  const isAccessible = creators.includes(currentUser.id);
  const isStatusPending = status === 'pending';

  return (
    <div className={`box ${pickColor(status)}_bg`}>
      {assignee && <CardUser {...assignee} />}

      <ActionItemBody
        id={id}
        assigneeId={assignee?.id}
        editable={isAccessible}
        deletable={isAccessible}
        body={body}
        users={users}
      />
      {isPrevious && (
        <ActionItemFooter
          id={id}
          timesMoved={times_moved}
          isReopanable={isAccessible && !isStatusPending}
          isCompletable={isAccessible && isStatusPending}
        />
      )}
    </div>
  );
};

export default ActionItem;
