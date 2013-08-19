{Resource} = require '../models/resource'
q = require 'q'

module.exports =
  all: -> q.ninvoke Resource.find(), "exec"
  get: (id) -> q.ninvoke Resource, "findById", id
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

    q.ninvoke resource, "save"

  edit: (id, newResource) ->
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

    q.ninvoke Resource, "update", _id: id, resource

  delete: (id) -> q.ninvoke Resource, "remove", _id: id
