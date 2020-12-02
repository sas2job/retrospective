import React, {useState} from 'react';
import {useMutation} from '@apollo/react-hooks';
import {destroyMembershipMutation} from './operations.gql';
import {getUserInitials} from '../../utils/helpers';

const User = props => {
  const {
    membership: {
      ready,
      id,
      user: {email, avatar, lastName, firstName}
    },
    shouldDisplayReady,
    shouldHandleDelete
  } = props;
  const [style, setStyle] = useState({});
  const [destroyMember] = useMutation(destroyMembershipMutation);
  const deleteUser = () => {
    destroyMember({
      variables: {
        id
      }
    }).then(({data}) => {
      if (data.destroyMembership.id) {
        if (shouldHandleDelete) {
          setStyle({display: 'none'});
        }
      } else {
        console.log(data.destroyMembership.errors.fullMessages.join(' '));
      }
    });
  };

  const renderBoardAvatar = (userAvatar, userName, userSurname) => {
    if (userAvatar) {
      return (
        <img
          src={avatar.thumb.url}
          className="board-avatar"
          alt={email}
          title={email}
        />
      );
    }

    return (
      <div className="board-avatar board-avatar--text">
        {getUserInitials(userName, userSurname)}
      </div>
    );
  };

  return (
    <div
      key={email}
      style={style}
      className={
        shouldDisplayReady && ready
          ? 'outer-circle is-success'
          : 'outer-circle is-info'
      }
    >
      <div className="avatar-wrapper">
        {renderBoardAvatar(avatar.thumb.url, firstName, lastName)}
        <div className="board-avatar__tooltip">
          {firstName} {lastName}
        </div>
      </div>

      {shouldHandleDelete && (
        <a className="delete is-small" onClick={deleteUser} />
      )}
    </div>
  );
};

export default User;
