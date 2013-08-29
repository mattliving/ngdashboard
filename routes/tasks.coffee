{Task} = require '../models/task'
q      = require 'q'

module.exports =
  all: -> q.ninvoke Task.find(), "exec"
  get: (name) -> q.ninvoke Task.findOne(name: name).populate('resources'), "exec"
