import path from 'path'
import express from 'express'
import favicon from 'serve-favicon'
import bodyParser from 'body-parser'
import cors from 'cors'
import compression from 'compression'
import routes from './routes'
import config from './config'
import loggers from './loggers'
import apicache from 'apicache'

const LEGIT_APP_SECRET = config.get('LEGIT_APP_SECRET')

const log = loggers.get('app')

const ensureLegitRequestSource = (req, res, next) => {
  log.info('Validating request')
  if (req.headers.xlegit !== LEGIT_APP_SECRET) {
    return res.status(401).json({ error: 'Not legit, must quit!' })
  }
  return next()
}

const app = express()

let cache = apicache.middleware
app.use(cache('1 week'))

app.use(cors())

app.use(bodyParser.urlencoded({ extended: true }))
app.use(bodyParser.json())

app.use(compression()) // Enable gzip

app.use("/", express.static(path.resolve(__dirname, '../static')))

const server = app.listen(process.env.PORT || 5000, () => {
  console.log(
    'Express server listening at http://%s:%s',
    server.address().address,
    server.address().port
  )
})
