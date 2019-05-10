export default function pick (o, ...fields) {
  return fields.reduce((a, x) => {
    if ({}.hasOwnProperty
      .call(o, x)) a[x] = o[x] // eslint-disable-line no-param-reassign
    return a
  }, {})
}
