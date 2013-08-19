{Resource} = require '../models/resource'
q = require 'q'

# simple function to resolve or reject a promise if there's an error
process = (promise, err, data) ->
  if err
    promise.reject err
  else
    promise.resolve data

module.exports =
  all: ->
    resources = q.defer()
    Resource.find().exec (err, data) ->
      process resources, err, data
    resources.promise
  get: (id) ->
    resource = q.defer()
    Resource.findById id, (err, data) ->
      process resource, err, data
    resource.promise
  add: (newResource) ->
    resource = new Resource
      authors:     newResource.authors
      topic:       newResource.topic
      mediaType:   newResource.mediaType
      title:       newResource.title
      link:        newResource.link
      level:       newResource.level
      path:        newResource.path
      cost:        newResource.cost
      description: newResource.description

    success = q.defer()
    resource.save (err) -> process success, err, success: true
    success.promise

  edit: (id, newResource) ->
    success = q.defer()
    resource =
      authors:     newResource.authors
      topic:       newResource.topic
      mediaType:   newResource.mediaType
      title:       newResource.title
      link:        newResource.link
      level:       newResource.level
      path:        newResource.path
      cost:        newResource.cost
      description: newResource.description
    Resource.update _id: id, resource, (err) ->
      process success, err, success: true
    success.promise

  delete: (id) ->
    success = q.defer()
    Resource.remove _id: id, (err) -> process success, err, success: true
    success.promise
