{Content} = require '../models/content'
q         = require 'q'

module.exports =
  get: (key) -> q.ninvoke Content.findOne(key: key), "exec"
