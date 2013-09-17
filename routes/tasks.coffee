{Task} = require '../models/task'
_      = require 'underscore'
q      = require 'q'

module.exports =
  all: -> q.ninvoke Task.find(), "exec"
  get: (name, group) ->
    taskPromise = q.defer()
    Task.findOne(name: name).populate('resources').exec (err, task) ->
      if err then return taskPromise.reject err
      unless task? then return taskPromise.reject code: 404, message: "No task named #{name} found"
      # must change to JSON otherwise mongoose changes the data to match
      # the schema. weird.
      task = task.toJSON()
      if group
        task.resources = _.groupBy task.resources, 'resourceType'
      taskPromise.resolve task
    return taskPromise.promise
  add: (newTask) ->
    task = new Task
      name: newTask.name
      title: newTask.title
      subtitle: newTask.subtitle
      overview: newTask.overview
      outcomes: newTask.outcomes
      resources: newTask.resources
    q.ninvoke task, "save"
  edit: (name, newTask) ->
    result = q.defer()
    Task.findOne name: name, (err, task) ->
      if err then return result.reject err
      task.name      = newTask.name
      task.title     = newTask.title
      task.subtitle  = newTask.subtitle
      task.overview  = newTask.overview
      task.outcomes  = newTask.outcomes
      task.resources = newTask.resources

      task.save (err) ->
        if err
          result.reject err
        else
          result.resolve task
    return result.promise
  delete: (name) -> q.ninvoke Task, "remove", name: name
