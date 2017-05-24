import { Router } from 'express'
import request from 'request-promise'
import config from './config'
import loggers from './loggers'

const router = new Router()

/*
 * ROUTES
 */

router.get('/health', (req, res) => {
  res.json({ status: 'alive' })
})

export default router
