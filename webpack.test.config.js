var path = require("path");
var merge = require( 'webpack-merge' );
var HtmlWebpackPlugin = require( 'html-webpack-plugin' );
var commonConfig = require('./webpack.common.config.js').commonConfig;
var additionalDevConfig = require('./webpack.common.config.js').additionalDevConfig;

module.exports = merge( {
      entry: {
        app: [
          './src/tests.js'
        ]
      },

      output: {
        path: path.resolve(__dirname + '/dist/tests'),
        filename: 'tests.[hash].js',
      },
      
      resolve: commonConfig.resolve,
      
      plugins: commonConfig.plugins,
      
    }, additionalDevConfig);