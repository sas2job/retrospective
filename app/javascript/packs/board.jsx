import React from 'react';
import ReactDOM from 'react-dom';
import {ApolloProvider} from 'react-apollo';
import {createClient} from '../utils/apollo';
import {CardsSubscription} from '../components/subscription/subscription';

const Board = () => (
  <div>
    <ApolloProvider client={createClient()}>
      <CardsSubscription />
    </ApolloProvider>
  </div>
);

document.addEventListener('DOMContentLoaded', () => {
  ReactDOM.render(<Board />, document.querySelector('#board'));
});
