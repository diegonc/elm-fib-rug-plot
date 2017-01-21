module.exports = {
  entry: './src/js/index.js',

  output: {
    path: './dist',
    filename: 'js/index.js'
  },

  resolve: {
    modulesDirectories: ['node_modules'],
    extensions: ['', '.js', '.elm']
  },

  module: {
    loaders: [
      {
        test: /\.html$/,
        exclude: /node_modules/,
        loader: 'file?name=[name].[ext]'
      },
      {
        test: /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/],
        loader: 'elm-webpack?verbose=true&warn=true&debug=true'
      },
      {
        test: /\.css$/,
        loader: 'style!css!'
      }
    ],

    noParse: /\.elm$/
  },

  devServer: {
    inline: true,
    stats: 'errors-only'
  }
};
