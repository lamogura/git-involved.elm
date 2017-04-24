import { Router } from 'express'
import request from 'request-promise'
import config from './config'
import loggers from './loggers'

const log = loggers.get('github')
// const GITHUB_API_KEY = config.get('GITHUB_API_KEY')
const GITHUB_URL = 'https://api.github.com'

const router = new Router()

/*
 * ROUTES
 */

// POST /api
// accepts a JSON object shaped for ex. to get the api call
// https://api.github.com/search/issues?q=language:javascript+is:open&sort=updated
// post this:
// {
//   "route": "search/issues"
//   "params": "q=language:javascript+is:open&sort=updated"
// }
//
router.post('/', (req, res) => {
  const { route, params } = req.body
  log.info(req.body)
  log.info(params)
  const url = `${GITHUB_URL}/${route}` + (params ? `?${params}` : '')
  log.info(`REQ GITHUB API: ${url}`)

  const reqOptions = {
    headers: { 'User-Agent': 'Git-Involved' },
    url,
  }

  request(reqOptions).then(res.json.bind(res)).catch(err => {
    // log.error(`GET FAILED`, err)
    res.json({ error: err })
  })
})

router.get('/health', (req, res) => {
  res.json({ status: 'alive' })
})

export default router
