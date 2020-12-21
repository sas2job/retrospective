import React, {useState, useEffect, useContext} from 'react';
import {useSubscription, useQuery} from '@apollo/react-hooks';
import {
  getMembershipsQuery,
  membershipUpdatedSubscription,
  membershipListUpdatedSubscription,
  membershipDestroyedSubscription
} from './operations.gql';
import User from '../user/user';
import BoardSlugContext from '../../utils/board-slug-context';

const MembershipList = () => {
  const boardSlug = useContext(BoardSlugContext);
  const [memberships, setMemberships] = useState([]);
  const [skipMutation, setSkipMutation] = useState(true);
  const [skipQuery, setSkipQuery] = useState(false);
  const {loading, data} = useQuery(getMembershipsQuery, {
    variables: {boardSlug},
    skip: skipQuery
  });

  useEffect(() => {
    if (!loading && Boolean(data)) {
      const {memberships} = data;
      setMemberships(memberships);
      setSkipQuery(true);
    }
  }, [data, loading]);

  useSubscription(membershipDestroyedSubscription, {
    skip: skipMutation,
    onSubscriptionData: (options) => {
      const {data} = options.subscriptionData;
      const {membershipDestroyed} = data;
      if (membershipDestroyed) {
        const {id} = membershipDestroyed;
        setMemberships(memberships.filter((it) => it.id !== id));
      }
    },
    variables: {boardSlug}
  });

  useSubscription(membershipUpdatedSubscription, {
    skip: skipMutation,
    onSubscriptionData: (options) => {
      const {data} = options.subscriptionData;
      const {membershipUpdated} = data;
      if (membershipUpdated) {
        const {id} = membershipUpdated;
        setMemberships((memberships) => {
          const objectIndex = memberships.findIndex((it) => it.id === id);
          return [
            ...memberships.slice(0, objectIndex),
            membershipUpdated,
            ...memberships.slice(objectIndex + 1)
          ];
        });
      }
    },
    variables: {boardSlug}
  });

  useSubscription(membershipListUpdatedSubscription, {
    skip: skipMutation,
    onSubscriptionData: (options) => {
      const {data} = options.subscriptionData;
      const {membershipListUpdated} = data;
      if (membershipListUpdated) {
        setMemberships((memberships) =>
          memberships.concat(membershipListUpdated)
        );
      }
    },
    variables: {boardSlug}
  });

  useEffect(() => {
    setSkipMutation(false);
  }, []);

  const usersListComponent = memberships.map((membership) => {
    return (
      <User
        key={membership.id}
        shouldDisplayReady
        membership={membership}
        shouldHandleDelete={false}
      />
    );
  });
  return <div className="tags">{usersListComponent}</div>;
};

export default MembershipList;
