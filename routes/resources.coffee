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
      cost:        newResource.cost
      description: newResource.description

    q.ninvoke resource, "save"

  edit: (id, newResource) ->
    # using find instead of update so middleware is called
    result = q.defer()
    Resource.findById id, (err, resource) ->
      resource.authors = newResource.authors
      resource.topic = newResource.topic
      resource.mediaType = newResource.mediaType
      resource.title = newResource.title
      resource.link = newResource.link
      resource.cost = newResource.cost
      resource.description = newResource.description

      resource.save (err) ->
        if err
          result.reject err
        else
          result.resolve resource
    return result.promise

  delete: (id) -> q.ninvoke Resource, "remove", _id: id
