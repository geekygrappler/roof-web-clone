var path = require('path')
var webpack = require('webpack')

module.exports = {
  cache: true,
  context: path.join(__dirname, 'webpack', 'javascripts'),
  entry: {
    application: './application',
  },
  output: {
    path: path.join(__dirname, 'app', 'assets', 'javascripts'),
    filename: '[name].bundle.js'
  },
  devtool: 'source-map',
  plugins: [
    new webpack.ProvidePlugin({
      riot: 'riot'
    })
  ],
  module: {
    preLoaders: [
      { test: /\.tag$/, exclude: /node_modules/, loader: 'riotjs-loader', query: { type: 'none' } }
    ],
    loaders: [
      {
        test: /\.js$|\.tag$/,
        exclude: /(node_modules|bower_components)/,
        loader: 'babel-loader',
        // query: {
        //   presets: ['es2015']
        // }
      }
    ]
  },
  externals: { jquery: "jQuery", underscore: "_" }
}
