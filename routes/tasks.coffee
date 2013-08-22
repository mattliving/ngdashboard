{Task} = require '../models/task'
q      = require 'q'

module.exports =
  all: -> q.ninvoke Task.find().populate('resources'), "exec"
  get: (name) -> q.ninvoke Task.findOne(name: name).populate('resources'), "exec"
