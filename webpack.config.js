var path = require("path");
var merge = require( 'webpack-merge' );
var HtmlWebpackPlugin = require( 'html-webpack-plugin' );
var ExtractTextPlugin = require("extract-text-webpack-plugin");

// detemine build env
var TARGET_ENV = process.env.npm_lifecycle_event === 'build' ? 'prod' : 'dev';

var commonConfig = {
  entry: {
    app: [
      './src/index.js'
    ]
  },

  output: {
    path: path.resolve(__dirname + '/dist'),
    filename: '[hash].js',
  },
  
  resolve: {
    modulesDirectories: ['node_modules'],
  },

  module: {
    loaders: [
      {
        test: /\.(css)$/,
        loader: ExtractTextPlugin.extract("style-loader", "css-loader")
      },
      {
        test: /\.woff(2)?(\?v=[0-9]\.[0-9]\.[0-9])?$/,
        loader: 'url-loader?limit=10000&minetype=application/font-woff',
      },
      {
        test: /\.(ttf|eot|svg)(\?v=[0-9]\.[0-9]\.[0-9])?$/,
        loader: 'file-loader',
      },
      {
        test: /\.(png|jpg)(\?v=[0-9]\.[0-9]\.[0-9])?$ /,
        loader: 'url-loader?limit=10000![name].[ext]?[hash]'
      }
    ],

    noParse: /\.elm$/,
  },
	
	plugins: [
		new ExtractTextPlugin('styles.[hash].css'),
    new HtmlWebpackPlugin({
      template: 'src/index.html',
      inject:   'body',
      filename: 'index.html'
    })
  ],

};

// additional webpack settings for local env (when invoked by 'npm run dev or npm run watch')
if ( TARGET_ENV === 'dev' ) {
	module.exports = merge( commonConfig, {

		devServer: {
		  inline: true,
			stats: 'errors-only'
		},

		module: {
			loaders: [
				{
					test: /\.elm$/,
					exclude: [/elm-stuff/, /node_modules/],
					loader: 'elm-hot!elm-webpack'
				}
			]
		}

  });
}

// additional webpack settings for prod env (when invoked via 'npm run build')
if ( TARGET_ENV === 'prod' ) {
	
	module.exports = merge( commonConfig, {

		module: {
			loaders: [
				{
					test: /\.elm$/,
					exclude: [/elm-stuff/, /node_modules/],
					loader: 'elm-webpack'
				}
			]
		},
		
		//TODO: perform optimizations!
		plugins: [
      // new webpack.optimize.OccurenceOrderPlugin(),

      // minify & mangle JS/CSS
      // new webpack.optimize.UglifyJsPlugin({
      //     minimize:   true,
      //     compressor: { warnings: false }
      //     // mangle:  true
      // })
    ]

  });
}