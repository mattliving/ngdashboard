{Project} = require '../models/project'
q         = require 'q'

module.exports =
  all: -> q.ninvoke Project.find(), 'exec'
  get: (name) ->
    projectPromise = q.defer()
    Project.findOne(name: name).populate('modules.tasks').exec (err, project) ->
      if err then return projectPromise.reject code: 404, message: err
      unless project? then return projectPromise.reject code: 404, message: "project not found"
      projectPromise.resolve project
    return projectPromise.promise
  add: (newProject) ->
    project = new Project
      name: newProject.name
      title: newProject.title
      subtitle: newProject.subtitle
      overview: newProject.overview
      type: newProject.type
      modules: newProject.modules
    q.ninvoke project, "save"
  edit: (name, newProject) ->
    result = q.defer()
    Project.findOne name: name, (err, project) ->
      if err then return result.reject code: 404, message: err
      unless project? then return result.reject code: 404, message: "nonexistent projects cannot be edited"
      project.name = newProject.name
      project.title = newProject.title
      project.subtitle = newProject.subtitle
      project.overview = newProject.overview
      project.type = newProject.type
      project.modules = newProject.modules

      project.save (err) ->
        if err
          result.reject code: 500, message: err
        else
          result.resolve project
    return result.promise
  delete: (name) -> q.ninvoke Project, "remove", name: name
