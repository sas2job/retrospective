import {nanoid} from 'nanoid';
import React, {useState, useContext, useEffect, useRef} from 'react';
import {useMutation} from '@apollo/react-hooks';
import Textarea from 'react-textarea-autosize';
import {addCardMutation} from './operations.gql';
import BoardSlugContext from '../../utils/board_slug_context';
import UserContext from '../../utils/user-context';

const NewCardBody = ({kind, onCardAdded, onGetNewCardID}) => {
  const textInput = useRef();
  const [isOpened, setOpened] = useState(false);
  const [newCard, setNewCard] = useState('');
  const [addCard] = useMutation(addCardMutation);

  const boardSlug = useContext(BoardSlugContext);
  const currentUser = useContext(UserContext);

  const toggleOpen = () => setOpened(!isOpened);

  useEffect(() => {
    if (isOpened) {
      textInput.current.focus();
    }
  }, [isOpened]);

  const cancelHandler = (evt) => {
    evt.preventDefault();
    setOpened(!isOpened);
    setNewCard('');
  };

  const buildNewCard = () => ({
    likes: 0,
    comments: [],
    kind,
    author: currentUser,
    body: newCard,
    id: `tmp-${nanoid()}`
  });

  const submitHandler = async (evt) => {
    const card = buildNewCard();
    evt.preventDefault();

    onCardAdded(card);

    const {data} = await addCard({
      variables: {
        boardSlug,
        kind,
        body: newCard
      }
    });
    if (data.addCard.card) {
      onGetNewCardID(card.id, data.addCard.card.id);
      setNewCard('');
    } else {
      console.log(data.addCard.errors.fullMessages.join(' '));
    }
  };

  const handleKeyPress = (evt) => {
    if (navigator.platform.includes('Mac')) {
      if (evt.key === 'Enter' && evt.metaKey) {
        submitHandler(evt);
      }
    } else if (evt.key === 'Enter' && evt.ctrlKey) {
      submitHandler(evt);
    }

    if (evt.key === 'Escape') {
      setOpened(!isOpened);
      setNewCard('');
    }
  };

  return (
    <>
      <div className="board-column-title">
        <h2 className="float_left">{kind.toUpperCase()}</h2>
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
              autoComplete="off"
              id={`card_${kind}_body`}
              value={newCard}
              onChange={(evt) => setNewCard(evt.target.value)}
              onKeyDown={handleKeyPress}
            />
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

export default NewCardBody;
