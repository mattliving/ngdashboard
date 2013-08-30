{Task} = require '../models/task'
_      = require 'underscore'
q      = require 'q'

module.exports =
  all: -> q.ninvoke Task.find(), "exec"
  get: (name) ->
    taskPromise = q.defer()
    Task.findOne(name: name).populate('resources').exec (err, task) ->
      # must change to JSON otherwise mongoose changes the data to match
      # the schema. weird.
      task = task.toJSON()
      task.resources = _.groupBy task.resources, 'resourceType'
      taskPromise.resolve task
    return taskPromise.promise
