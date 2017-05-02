var path = require('path')
var webpack = require('webpack')
var merge = require('webpack-merge')
var HtmlWebpackPlugin = require('html-webpack-plugin')
var ExtractTextPlugin = require('extract-text-webpack-plugin')
var CleanWebpackPlugin = require('clean-webpack-plugin')
var CopyWebpackPlugin = require('copy-webpack-plugin')
var entryPath = path.join(__dirname, 'frontend/static/index.js')
var outputPath = path.join(__dirname, 'dist')

// determine build env
var TARGET_ENV = process.env.npm_lifecycle_event === 'build'
  ? 'production'
  : 'development'

var outputFilename = TARGET_ENV === 'production'
  ? '[name]-[hash].js'
  : '[name].js'

// common webpack config
var commonConfig = {
  output: {
    path: outputPath,
    filename: `./frontend/static/js/${outputFilename}`,
    // publicPath: '/'
  },

  resolve: {
    extensions: ['.js', '.elm'],
  },

  module: {
    noParse: /\.elm$/,
    loaders: [
      {
        test: /\.(eot|ttf|woff|woff2|svg)$/,
        loader: 'file-loader',
      },
    ],
  },

  plugins: [
    new HtmlWebpackPlugin({
      template: './frontend/static/index.html',
      inject: 'body',
      filename: 'index.html',
    }),
  ],
}

// additional webpack settings for local env (when invoked by 'npm start')
if (TARGET_ENV === 'development') {
  console.log('Serving locally...')

  module.exports = merge(commonConfig, {
    entry: ['webpack-dev-server/client?http://localhost:8080', entryPath],

    devServer: {
      // serve index.html in place of 404 responses
      historyApiFallback: true,
      contentBase: './frontend',
      proxy: {
        '/api/*': 'http://localhost:5000',
      },
    },

    module: {
      loaders: [
        {
          test: /\.elm$/,
          exclude: [/elm-stuff/, /node_modules/],
          loader: 'elm-hot-loader!elm-webpack-loader?verbose=true&warn=true&debug=true',
        },
        {
          test: /\.(css|scss)$/,
          loaders: ['style-loader', 'css-loader', 'postcss-loader'],
        },
      ],
    },
  })
}

// additional webpack settings for prod env (when invoked via 'npm run build')
if (TARGET_ENV === 'production') {
  console.log('Building for prod...')

  module.exports = merge(commonConfig, {
    entry: entryPath,

    module: {
      loaders: [
        {
          test: /\.elm$/,
          exclude: [/elm-stuff/, /node_modules/],
          loader: 'elm-webpack-loader',
        },
        {
          test: /\.(css|scss)$/,
          loader: ExtractTextPlugin.extract({
            fallback: 'style-loader',
            use: ['css-loader', 'postcss-loader'],
          }),
        },
      ],
    },

    plugins: [
      new CleanWebpackPlugin(['dist']),
      new CopyWebpackPlugin([
        {
          from: 'frontend/static/img/',
          to: 'static/img/',
        },
        {
          from: 'frontend/static/favicon.ico',
        },
      ]),

      new webpack.optimize.OccurrenceOrderPlugin(),

      // extract CSS into a separate file
      new ExtractTextPlugin({
        filename: 'static/css/[name]-[hash].css',
        allChunks: true,
      }),

      // minify & mangle JS/CSS
      new webpack.optimize.UglifyJsPlugin({
        minimize: true,
        compressor: { warnings: false },
        // mangle:  true
      }),
    ],
  })
}
