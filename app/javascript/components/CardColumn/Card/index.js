import React, {useContext, useMemo} from 'react';
import UserContext from '../../../utils/user_context';
import CardBody from './CardBody';
import CardFooter from './CardFooter';
import CardUser from './card-user/card-user.jsx';
import './Card.css';

const Card = ({
  card: {
    id,
    body,
    author: {
      nickname,
      last_name,
      first_name,
      email,
      avatar: {
        thumb: {url}
      }
    },
    commentsNumber,
    likes
  },
  type,
  onCommentButtonClick
}) => {
  const user = useContext(UserContext);

  const isTempId = id => {
    return id.toString().startsWith('tmp-');
  };

  const editable = useMemo(() => !isTempId(id) && user === email, [id]);
  const deletable = user === email;
  return (
    <div className="box">
      <CardUser
        avatar={url}
        name={nickname}
        firstName={first_name}
        lastName={last_name}
        nickname={nickname}
      />
      <CardBody id={id} editable={editable} deletable={deletable} body={body} />
      <CardFooter
        id={id}
        likes={likes}
        type={type}
        commentsNumber={commentsNumber}
        onCommentButtonClick={onCommentButtonClick}
      />
    </div>
  );
};

export default Card;
