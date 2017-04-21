// pull in desired CSS files
require('./styles/main.css')

// inject bundled Elm app into div#app
var Elm = require('../app/App')
Elm.App.embed(document.getElementById('app'))
