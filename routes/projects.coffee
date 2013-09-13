{Project} = require '../models/project'
q         = require 'q'

module.exports =
  all: -> q.ninvoke Project.find(), 'exec'
  get: (name) ->
    q.ninvoke Project.findOne(name: name).populate('modules.tasks'), "exec"
