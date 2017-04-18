'use strict'

require('font-awesome/css/font-awesome.css')
require('./index.html')

var Elm = require('./App.elm')
var mountNode = document.getElementById('app')

var app = Elm.App.embed(mountNode)
