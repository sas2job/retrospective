import React, {useState, useEffect, useContext} from 'react';
import {useMutation, useQuery, useSubscription} from '@apollo/react-hooks';
import {
  toggleReadyStatusMutation,
  getMembershipQuery,
  membershipUpdatedSubscription
} from './operations.gql';
import BoardSlugContext from '../../utils/board_slug_context';

const ReadyButton = () => {
  const boardSlug = useContext(BoardSlugContext);
  const [isReady, setIsReady] = useState(false);
  const [id, setId] = useState(0);
  const [skipQuery, setSkipQuery] = useState(false);
  const [skipSubscription, setSkipSubscription] = useState(true);
  const {loading, data} = useQuery(getMembershipQuery, {
    variables: {boardSlug},
    skip: skipQuery
  });
  const [toggleReadyStatus] = useMutation(toggleReadyStatusMutation);

  useSubscription(membershipUpdatedSubscription, {
    skip: skipSubscription,
    onSubscriptionData: opts => {
      const {data} = opts.subscriptionData;
      const {membershipUpdated} = data;
      if (membershipUpdated && membershipUpdated.id === id) {
        setIsReady(membershipUpdated.ready);
      }
    },
    variables: {boardSlug}
  });

  useEffect(() => {
    if (!loading && Boolean(data)) {
      const {membership} = data;
      setId(membership.id);
      setIsReady(membership.ready);
      setSkipQuery(true);
    }
  }, [data, loading]);

  useEffect(() => {
    setSkipSubscription(false);
  }, []);

  return (
    <button
      className={`board-button ${isReady ? 'is-success' : ''}`}
      type="button"
      onClick={() => {
        toggleReadyStatus({
          variables: {
            id
          }
        }).then(({data}) => {
          if (!data.toggleReadyStatus.membership) {
            console.log(data.toggleReadyStatus.errors.fullMessages.join(' '));
          }
        });
      }}
    >
      READY
    </button>
  );
};

export default ReadyButton;
