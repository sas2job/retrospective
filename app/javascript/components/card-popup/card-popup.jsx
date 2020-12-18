import React from 'react';
import {CommentsDropdown} from '../comments-dropdown';
import {Card} from '../card';
import './style.css';

const CardPopup = ({card, type, onCommentButtonClick, onClickClosed}) => {
  const {id, comments} = card;
  const handlePopupClosed = (evt) => {
    if (evt.target.classList.contains('card-popup')) {
      onClickClosed();
    }
  };

  return (
    <div className="card-popup" onClick={handlePopupClosed}>
      <div className="card-popup__inner">
        <Card
          {...card}
          type={type}
          onCommentButtonClick={onCommentButtonClick}
        />
        <CommentsDropdown
          id={id}
          comments={comments}
          onClickClosed={onClickClosed}
        />
      </div>
    </div>
  );
};

export default CardPopup;
