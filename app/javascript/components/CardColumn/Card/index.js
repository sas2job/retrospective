import React, {useContext, useMemo} from 'react';
import UserContext from '../../../utils/user-context';
import CardBody from './CardBody';
import CardFooter from './CardFooter';
import CardUser from './card-user/card-user';
import './Card.css';

const Card = ({
  id,
  body,
  author,
  comments,
  likes,
  type,
  onCommentButtonClick
}) => {
  const currentUser = useContext(UserContext);

  const isTemporaryId = (id) => {
    return id.toString().startsWith('tmp-');
  };

  const editable = useMemo(
    () => !isTemporaryId(id) && currentUser.id === author.id,
    [id, currentUser.id, author.id]
  );

  return (
    <div className="box">
      <CardUser {...author} />
      <CardBody id={id} editable={editable} body={body} />
      <CardFooter
        id={id}
        likes={likes}
        type={type}
        commentsNumber={comments.length}
        onCommentButtonClick={onCommentButtonClick}
      />
    </div>
  );
};

export default Card;
