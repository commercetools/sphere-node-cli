/* eslint-disable import/no-extraneous-dependencies */
import { Before, After } from 'cucumber'

/* eslint-disable new-cap */
Before((scenario, callback) => {
  // TODO: prepare environment
  // - cleanup
  // - credentials
  callback()
})

After((scenario, callback) => {
  // TODO: cleanup environment
  callback()
})
