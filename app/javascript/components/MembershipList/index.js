import React, {useState, useEffect, useContext} from 'react';
import {useSubscription, useQuery} from '@apollo/react-hooks';
import {
  getMembershipsQuery,
  membershipUpdatedSubscription,
  membershipListUpdatedSubscription,
  membershipDestroyedSubscription
} from './operations.gql';
import User from '../User';
import BoardSlugContext from '../../utils/board_slug_context';

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
    onSubscriptionData: opts => {
      const {data} = opts.subscriptionData;
      const {membershipDestroyed} = data;
      if (membershipDestroyed) {
        const {id} = membershipDestroyed;
        setMemberships(memberships => memberships.filter(el => el.id !== id));
      }
    },
    variables: {boardSlug}
  });

  useSubscription(membershipUpdatedSubscription, {
    skip: skipMutation,
    onSubscriptionData: opts => {
      const {data} = opts.subscriptionData;
      const {membershipUpdated} = data;
      if (membershipUpdated) {
        const {id} = membershipUpdated;
        setMemberships(memberships => {
          const objIndex = memberships.findIndex(obj => obj.id === id);
          return [
            ...memberships.slice(0, objIndex),
            membershipUpdated,
            ...memberships.slice(objIndex + 1)
          ];
        });
      }
    },
    variables: {boardSlug}
  });

  useSubscription(membershipListUpdatedSubscription, {
    skip: skipMutation,
    onSubscriptionData: opts => {
      const {data} = opts.subscriptionData;
      const {membershipListUpdated} = data;
      if (membershipListUpdated) {
        setMemberships(memberships =>
          memberships.concat(membershipListUpdated)
        );
      }
    },
    variables: {boardSlug}
  });

  useEffect(() => {
    setSkipMutation(false);
  }, []);

  const usersListComponent = memberships.map(membership => {
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
