{Type} = require '../models/type'
q      = require 'q'

module.exports =
  get: (type) -> q.ninvoke Type.find({type: type}, {key: true, value: true}), "exec"
  all: -> q.ninvoke Type.find(), "exec"
