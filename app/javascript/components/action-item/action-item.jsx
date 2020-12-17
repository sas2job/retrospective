import React, {useContext} from 'react';
import ActionItemBody from '../action-item-body/action-item-body';
import ActionItemFooter from '../action-item-footer/action-item-footer';
import './style.css';
import UserContext from '../../utils/user-context';
import CardUser from '../card-user/card-user';

const ActionItem = ({
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
  const isStatusPending = status === 'pending';

  return (
    <div className={`box ${pickColor(status)}_bg`}>
      {assignee && <CardUser {...assignee} />}

      <ActionItemBody
        id={id}
        assigneeId={assignee?.id}
        editable={currentUser.isCreator}
        deletable={currentUser.isCreator}
        body={body}
        users={users}
      />
      {isPrevious && (
        <ActionItemFooter
          id={id}
          timesMoved={times_moved}
          isReopanable={currentUser.isCreator && !isStatusPending}
          isCompletable={currentUser.isCreator && isStatusPending}
        />
      )}
    </div>
  );
};

export default ActionItem;
