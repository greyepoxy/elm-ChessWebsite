var merge = require( 'webpack-merge' );
var commonConfig = require('./webpack.common.config.js').commonConfig;

// detemine build env
var TARGET_ENV = process.env.npm_lifecycle_event === 'build' ? 'prod' : 'dev';

// additional webpack settings for local env (when invoked by 'npm run dev or npm run watch')
if ( TARGET_ENV === 'dev' ) {
  var additionalDevConfig = require('./webpack.common.config.js').additionalDevConfig;
  
	module.exports = merge(additionalDevConfig, commonConfig);
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
			],
      
      noParse: /\.elm$/,
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