import React from 'react';
import {Likes} from '../likes';
import './style.less';

const CardFooter = ({
  id,
  likes,
  type,
  commentsNumber,
  onCommentButtonClick
}) => {
  return (
    <div className="card-footer">
      <div className="card-footer__likes">
        <Likes id={id} likes={likes} type={type} />
      </div>
      <div className="card-footer__comments">
        <a onClick={onCommentButtonClick}>
          {commentsNumber ? `add a comment` : `see ${commentsNumber} comments`}
        </a>
      </div>
    </div>
  );
};

export default CardFooter;
