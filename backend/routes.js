import { Router } from 'express'
// import { inspect } from 'util'
import config from './config'
import loggers from './loggers'

// const GITHUB_API_KEY = config.get('GITHUB_API_KEY')
const log = loggers.get('github')

const router = new Router()

/*
 * ROUTES
 */

router.get('/', (req, res, next) => {
  // const {endpoint, q} = req.body

  res.json({ it: 'worked' })
})

export default router
