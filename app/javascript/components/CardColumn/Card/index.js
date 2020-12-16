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

  const isCurrentUserAuthor =
    currentUser.id.toString() === author.id.toString(); // Temporary solution for matching data types (after edit card it will still availible to edit)

  const editable = useMemo(() => !isTemporaryId(id) && isCurrentUserAuthor, [
    id,
    isCurrentUserAuthor
  ]);

  const deletable = useMemo(
    () => !isTemporaryId(id) && (isCurrentUserAuthor || currentUser.isCreator),
    [id, isCurrentUserAuthor]
  );

  return (
    <div className="box">
      <CardUser {...author} />
      <CardBody id={id} editable={editable} deletable={deletable} body={body} />
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
