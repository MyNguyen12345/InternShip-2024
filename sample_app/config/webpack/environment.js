const { environment } = require('@rails/webpacker')
const webpack = require('webpack')
environment.config.merge({
  node: false,
})
environment.plugins.prepend('Provide',
  new webpack.ProvidePlugin({
    $: 'jquery/src/jquery',
    jQuery: 'jquery/src/jquery'
  })
)
module.exports = environment
