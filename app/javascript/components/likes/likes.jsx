import React, {useState, useEffect} from 'react';
import {useMutation} from '@apollo/react-hooks';
import {likeCardMutation} from './operations.gql';
const EMOJIES = {
  mad: '😡',
  sad: '😔',
  glad: '🤗',
  universal: '👍'
};

const Likes = ({type, likes, id}) => {
  const [likeCard] = useMutation(likeCardMutation);
  const [style, setStyle] = useState('has-text-info');
  const [timer, setTimer] = useState(null);

  useEffect(() => {
    return function () {
      clearInterval(timer);
    };
  }, [timer]);

  const addLike = () => {
    likeCard({
      variables: {
        id
      }
    }).then(({data}) => {
      if (!data.likeCard.card) {
        console.log(data.likeCard.errors.fullMessages.join(' '));
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
        {EMOJIES[type] || EMOJIES.universal}
      </a>
      <span> {likes} </span>
    </>
  );
};

export default Likes;
