require('dotenv-safe').load({ silent: true })
require('babel-core/register')
require('babel-polyfill')
require('./backend/app')
