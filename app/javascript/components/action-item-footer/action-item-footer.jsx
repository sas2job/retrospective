import React, {useContext} from 'react';
import {moveActionItemMutation} from './operations.gql';
import {useMutation} from '@apollo/react-hooks';
import {TransitionButton} from '../transition-button';
import BoardSlugContext from '../../utils/board_slug_context';
import './style.css';
const ActionItemFooter = ({id, isReopanable, isCompletable, timesMoved}) => {
  const boardSlug = useContext(BoardSlugContext);
  const [moveActionItem] = useMutation(moveActionItemMutation);
  const handleMoveClick = () => {
    moveActionItem({
      variables: {
        id,
        boardSlug
      }
    }).then(({data}) => {
      if (!data.moveActionItem.actionItem) {
        console.log(data.moveActionItem.errors.fullMessages.join(' '));
      }
    });
  };

  const pickColor = (number) => {
    switch (true) {
      case [1, 2].includes(number):
        return 'green';
      case [3].includes(number):
        return 'yellow';
      default:
        return 'red';
    }
  };

  const generateChevrons = () => {
    const chevrons = Array.from({length: timesMoved}, (_, index) => (
      <i
        key={index}
        className={`fas fa-chevron-right ${pickColor(timesMoved)}_font`}
      />
    ));
    return chevrons;
  };

  return (
    <div>
      <hr style={{margin: '0.5rem'}} />
      <div className="chevrons">{generateChevrons()}</div>

      {isCompletable && (
        <>
          <TransitionButton id={id} action="close" />
          <TransitionButton id={id} action="complete" />
        </>
      )}
      {isReopanable && <TransitionButton id={id} action="reopen" />}
      {isCompletable && (
        <button
          type="button"
          onClick={() => {
            window.confirm('Are you sure you want to move this ActionItem?') &&
              handleMoveClick();
          }}
        >
          move
        </button>
      )}
    </div>
  );
};

export default ActionItemFooter;
