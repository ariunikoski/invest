const { environment } = require('@rails/webpacker');
const babelLoader = environment.loaders.get('babel');

const webpack = require('webpack');
environment.plugins.prepend('Provide',
	  new webpack.ProvidePlugin({
		      Turbolinks: 'turbolinks'
		    })
);
environment.plugins.prepend('Provide',
	  new webpack.ProvidePlugin({
		      Rails: '@rails/ujs'
		    })
);





babelLoader.use[0].options.plugins = (babelLoader.use[0].options.plugins || []).concat([
	  ['@babel/plugin-proposal-class-properties', { "loose": true }],
	  ['@babel/plugin-proposal-private-methods', { "loose": true }],
	  ['@babel/plugin-proposal-private-property-in-object', { "loose": true }]
]);

module.exports = environment;





