import React from 'react';
import {getUserInitials} from '../../../../utils/helpers';

const CardUserAvatar = ({avatar, firstName, lastName}) => {
  const renderAvatar = (userAvatar, userName, userSurname) => {
    if (userAvatar) {
      return <img src={userAvatar} className="avatar" />;
    }

    return (
      <div className="avatar avatar--text">
        {getUserInitials(userName, userSurname)}
      </div>
    );
  };

  return renderAvatar(avatar, firstName, lastName);
};

export default CardUserAvatar;
