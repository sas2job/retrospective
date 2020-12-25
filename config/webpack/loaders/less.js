const path = require('path');
const getStyleRule = require('@rails/webpacker/package/utils/get_style_rule');

module.exports = getStyleRule(/\.less$/i, true, [
  {
    loader: 'less-loader',
    options: {
      lessOptions: {
        paths: [path.resolve(__dirname, 'node_modules')],
        strictMath: true
      }
    }
  }
]);
