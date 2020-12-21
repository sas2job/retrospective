const {environment} = require('@rails/webpacker');

environment.loaders.append('graphql', {
  test: /\.(?<id>graphql|gql)$/,
  exclude: /node_modules/,
  loader: 'graphql-tag/loader'
});

const less = require('./loaders/less');
environment.loaders.append('less', less);

module.exports = environment;

// Added due to issues with @rails/actioncable being transpiled by babel-loader
// https://github.com/rails/webpacker/blob/master/docs/v4-upgrade.md#excluding-node_modules-from-being-transpiled-by-babel-loader
// https://github.com/rails/rails/issues/35501#issuecomment-555312633
const nodeModulesLoader = environment.loaders.get('nodeModules');
if (!Array.isArray(nodeModulesLoader.exclude)) {
  nodeModulesLoader.exclude =
    nodeModulesLoader.exclude === null ? [] : [nodeModulesLoader.exclude];
}

nodeModulesLoader.exclude.push(/@rails\/actioncable/);
