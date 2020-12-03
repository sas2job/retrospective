import React, {useState, useContext, useEffect, useRef} from 'react';
import {useMutation} from '@apollo/react-hooks';
import Textarea from 'react-textarea-autosize';
import {addActionItemMutation} from '../operations.gql';
import BoardSlugContext from '../../../utils/board_slug_context';

const ActionItemColumnHeader = ({users}) => {
  const textInput = useRef();
  const [isOpened, setOpened] = useState(false);
  const [newActionItemBody, setNewActionItemBody] = useState('');
  const [newActionItemAssignee, setNewActionItemAssignee] = useState('');
  const [addActionItem] = useMutation(addActionItemMutation);
  const boardSlug = useContext(BoardSlugContext);

  const toggleOpen = () => setOpened(!isOpened);

  useEffect(() => {
    if (isOpened) {
      textInput.current.focus();
    }
  }, [isOpened]);

  const cancelHandler = e => {
    e.preventDefault();
    setOpened(isOpened => !isOpened);
    setNewActionItemBody('');
  };

  const submitHandler = e => {
    e.preventDefault();
    setOpened(isOpened => !isOpened);
    addActionItem({
      variables: {
        boardSlug,
        assigneeId: newActionItemAssignee,
        body: newActionItemBody
      }
    }).then(({data}) => {
      if (data.addActionItem.actionItem) {
        setNewActionItemBody('');
      } else {
        console.log(data.addActionItem.errors.fullMessages.join(' '));
      }
    });
  };

  const handleKeyPress = e => {
    if (navigator.platform.includes('Mac')) {
      if (e.key === 'Enter' && e.metaKey) {
        submitHandler(e);
      }
    } else if (e.key === 'Enter' && e.ctrlKey) {
      submitHandler(e);
    }

    if (e.key === 'Escape') {
      setOpened(isOpened => !isOpened);
      setNewActionItemBody('');
    }
  };

  return (
    <>
      <div className="board-column-title">
        <h2 className="float_left">ACTION ITEMS</h2>
        <div className="float_right card-new" onClick={toggleOpen}>
          +
        </div>
      </div>
      {isOpened && (
        <div>
          <form onSubmit={submitHandler}>
            <Textarea
              ref={textInput}
              className="input"
              value={newActionItemBody}
              id="action_item_body`"
              onChange={e => setNewActionItemBody(e.target.value)}
              onKeyDown={handleKeyPress}
            />

            <div className="board-select-column">
              <select
                className="select width_100"
                onChange={e => setNewActionItemAssignee(e.target.value)}
              >
                <option value=" ">Assigned to ...</option>
                {users.map(user => {
                  return (
                    <option key={user.id} value={user.id}>
                      {user.nickname}
                    </option>
                  );
                })}
              </select>
            </div>
            <div className="card-buttons">
              <button
                className="tag is-success button card-add"
                type="submit"
                onSubmit={submitHandler}
              >
                Add
              </button>
              <button
                className="tag button card-cancel"
                type="submit"
                onClick={cancelHandler}
              >
                Cancel
              </button>
            </div>
          </form>
        </div>
      )}
    </>
  );
};

export default ActionItemColumnHeader;
