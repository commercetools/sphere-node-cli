/* eslint-disable new-cap */
export default function hooks () {
  this.Before((scenario, callback) => {
    // TODO: prepare environment
    // - cleanup
    // - credentials
    callback()
  })

  this.After((scenario, callback) => {
    // TODO: cleanup environment
    callback()
  })
}
