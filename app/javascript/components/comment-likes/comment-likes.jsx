import React, {useState, useEffect} from 'react';
import {useMutation} from '@apollo/react-hooks';
import {likeCommentMutation} from './operations.gql';
const EMOJI = '👍';

const CommentLikes = ({likes, id}) => {
  const [likeComment] = useMutation(likeCommentMutation);
  const [style, setStyle] = useState('has-text-info');
  const [timer, setTimer] = useState(null);

  useEffect(() => {
    return function () {
      clearInterval(timer);
    };
  }, [timer]);

  const addLike = () => {
    likeComment({
      variables: {
        id
      }
    }).then(({data}) => {
      if (!data.likeComment.comment) {
        console.log(data.likeComment.errors.fullMessages.join(' '));
      }
    });
  };

  const handleMouseDown = () => {
    setStyle({style: 'has-text-success'});
    addLike();
    const timer = setInterval(() => addLike(), 300);
    setTimer(timer);
  };

  const handleMouseUp = (currentTimer) => {
    setStyle('has-text-info');
    clearInterval(currentTimer);
  };

  const handleMouseLeave = (currentTimer) => {
    setStyle('has-text-info');
    clearInterval(currentTimer);
  };

  return (
    <>
      <a
        className={style}
        onMouseDown={handleMouseDown}
        onMouseUp={() => handleMouseUp(timer)}
        onMouseLeave={() => handleMouseLeave(timer)}
      >
        {EMOJI}
      </a>
      <span> {likes} </span>
    </>
  );
};

export default CommentLikes;
