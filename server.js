'use strict'

const path = require('path')
const express = require('express')
const favicon = require('serve-favicon')
const compression = require('compression')

const app = express()

// Enable gzip
app.use(compression())

app.use(favicon(path.resolve(__dirname, 'dist', 'favicon.ico')))

app.use(express.static(path.resolve(__dirname, 'dist')))

// Render files
app.get('*', function(req, res) {
  res.render('index')
})

const server = app.listen(process.env.PORT || 9000, function() {
  console.log(
    'Express server listening at http://%s:%s',
    server.address().address,
    server.address().port
  )
})
