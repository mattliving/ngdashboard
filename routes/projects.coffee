{Project} = require '../models/project'
q         = require 'q'

module.exports =
  all: -> q.ninvoke Project.find(), 'exec'
  get: (name) ->
    q.ninvoke Project.findOne(name: name).populate('modules.tasks'), "exec"
  add: (newProject) ->
    project = new Project
      name: newProject.name
      title: newProject.title
      description: newProject.description
      type: newProject.type
      modules: newProject.modules
    q.ninvoke project, "save"
  edit: (name, newProject) ->
    result = q.defer()
    Project.findOne name: name, (err, project) ->
      if err then return result.reject err
      project.name = newProject.name
      project.title = newProject.title
      project.description = newProject.description
      project.type = newProject.type
      project.modules = newProject.modules

      project.save (err) ->
        if err
          result.reject err
        else
          result.resolve project
    return result.promise
  delete: (name) -> q.ninvoke Project, "remove", name: name
