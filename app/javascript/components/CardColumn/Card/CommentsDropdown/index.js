import React, {useRef, useState, useContext, useEffect} from 'react';
import Picker from 'emoji-picker-react';
import {FontAwesomeIcon} from '@fortawesome/react-fontawesome';
import {faSmile} from '@fortawesome/free-regular-svg-icons';
import UserContext from '../../../../utils/user-context';
import Comment from './Comment';
import {useMutation} from '@apollo/react-hooks';
import {addCommentMutation} from './operations.gql';

const CommentsDropdown = ({id, comments}) => {
  const controlElement = useRef(null);
  const textInput = useRef();
  const [showEmojiPicker, setShowEmojiPicker] = useState(false);
  const [isError, setIsError] = useState(false);
  const user = useContext(UserContext);
  const [newComment, setNewComment] = useState('');
  const [addComment] = useMutation(addCommentMutation);

  useEffect(() => {
    textInput.current.focus();
  }, []);

  const handleErrorSubmit = () => {
    setNewComment('');
    setIsError(true);
  };

  const handleSuccessSubmit = () => {
    setNewComment('');
    setIsError(false);
  };

  const handleSubmit = () => {
    controlElement.current.disabled = true;
    addComment({
      variables: {
        cardId: id,
        content: newComment
      }
    }).then(({data}) => {
      if (data.addComment.comment) {
        handleSuccessSubmit();
      } else {
        console.log(data.addComment.errors.fullMessages.join(' '));
        handleErrorSubmit();
      }
    });
    controlElement.current.disabled = false;
    setShowEmojiPicker(false);
  };

  const handleSmileClick = () => {
    setShowEmojiPicker((isShown) => !isShown);
  };

  const handleEmojiPickerClick = (_, emoji) => {
    setNewComment((comment) => `${comment}${emoji.emoji}`);
  };

  const handleKeyPress = (evt) => {
    if (navigator.platform.includes('Mac')) {
      if (evt.key === 'Enter' && evt.metaKey) {
        handleSubmit(evt);
      }
    } else if (evt.key === 'Enter' && evt.ctrlKey) {
      handleSubmit(evt);
    }
  };

  return (
    <div className="column comments-column">
      <div className="dropdown-comments-menu" role="menu">
        <div className="dropdown-comments-content">
          <div className="textarea-container dropdown-item">
            <textarea
              ref={textInput}
              className="textarea"
              value={newComment}
              style={isError ? {outline: 'solid 1px red'} : {}}
              onChange={(evt) => setNewComment(evt.target.value)}
              onKeyDown={handleKeyPress}
            />
            <div className="edit-panel-wrapper">
              <a className="has-text-info" onClick={handleSmileClick}>
                <FontAwesomeIcon icon={faSmile} />
              </a>
              <button
                ref={controlElement}
                className="button is-small"
                type="button"
                onClick={() => handleSubmit(newComment)}
              >
                Add comment
              </button>
            </div>
          </div>
          {showEmojiPicker && (
            <Picker
              style={{width: 'auto'}}
              onEmojiClick={handleEmojiPickerClick}
            />
          )}
          {comments.map((item) => (
            <Comment
              key={item.id}
              id={item.id}
              comment={item}
              deletable={user === item.author.email}
              editable={user === item.author.email}
            />
          ))}
        </div>
      </div>
    </div>
  );
};

export default CommentsDropdown;
