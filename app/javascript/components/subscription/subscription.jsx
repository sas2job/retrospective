import React, {Component} from 'react';
import gql from 'graphql-tag';
import {Query} from 'react-apollo';

const GET_BOARDS = gql`
  query {
    board(id: 10) {
      cards {
        id
        body
        likes
        author {
          email
        }
      }
    }
  }
`;

const NEW_CARD = gql`
  subscription {
    cardAdded {
      author {
        id
        email
        avatar
        updatedAt
        createdAt
      }
      id
      authorId
      boardId
      body
      likes
      updatedAt
      createdAt
      kind
    }
  }
`;

class CardsSubscription extends Component {
  _subscribeToNewCards = (subscribeToMore) => {
    subscribeToMore({
      document: NEW_CARD,
      updateQuery: (previous, {subscriptionData}) => {
        if (!subscriptionData.data) return previous;

        const newCard = subscriptionData.data.cardAdded;

        return {
          ...previous,
          cards: [newCard, ...previous.board.cards],
          __typename: previous.board.cards__typename
        };
      }
    });
  };

  render() {
    return (
      <Query query={GET_BOARDS}>
        {({loading, error, data, subscribeToMore}) => {
          if (loading) return <div>Fetching</div>;
          if (error) return <div>Error</div>;

          this._subscribeToNewCards(subscribeToMore);

          const cardsToRender = data.board.cards;
          return (
            <ul>
              {cardsToRender.map((card) => (
                <li key={card.id}>
                  {card.body} {card.author.email} {card.likes}
                </li>
              ))}
            </ul>
          );
        }}
      </Query>
    );
  }
}

export default CardsSubscription;
