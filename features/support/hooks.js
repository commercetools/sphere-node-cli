/* eslint-disable new-cap */
export default function hooks () {
  this.Before(callback => {
    // TODO: prepare environment
    // - cleanup
    // - credentials
    callback()
  })

  this.After(callback => {
    // TODO: cleanup environment
    callback()
  })
}
