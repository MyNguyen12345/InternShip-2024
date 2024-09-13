const { environment } = require('@rails/webpacker')
environment.config.merge({
    node: false,
})
const webpack = require('webpack')
environment.plugins.prepend('Provide',
new webpack.ProvidePlugin({
$: 'jquery/src/jquery',
jQuery: 'jquery/src/jquery'
})
)
module.exports = environment
