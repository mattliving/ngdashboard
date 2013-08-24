'use strict'

angular.module 'jobFoundryServices', []

# simple key creation from values for now, may be more complex later
angular.module('jobFoundryServices').factory 'keygen', -> (string) -> string.toLowerCase().replace(" ", "")

angular.module('jobFoundryServices').service 'Resources', class Resources

  # ngmin can't detect the dependencies in CoffeeScript's class syntax
  Resources.$inject = ['$http', '$q', '$rootScope']
  constructor: (@$http, @$q, @$rootScope) ->
    @fetch()

  fetch: ->
    @resources = @$q.defer()
    @$http.get('/api/v1/resources')
      .success (data, status) =>
        @resources.resolve data
      .error =>
        console.log 'data error has occurred'
        @resources.reject 'error fetching data'

  get: (id) ->
    if id?
      resource = @$q.defer()
      @$http.get("/api/v1/resources/#{id}")
        .success (data) ->
          resource.resolve data
        .error ->
          console.log 'error getting specific id'
          resource.reject 'error getting specific id'

      resource.promise
    else
      @resources.promise

  add: (resource) ->
    response = @$q.defer()
    @$http.post('/api/v1/resources', resource)
      .success (data) =>
        console.log data
        response.resolve success: true
        @resources.promise.then (resources) ->
          resource._id = data[0]._id
          resources.unshift resource
      .error (data) ->
        data.success = false
        response.resolve data
        console.log 'server error has occurred', data

    response.promise

  edit: (resource) ->
    response = @$q.defer()
    @$http.put("/api/v1/resources/#{resource._id}", resource)
      .success (data) =>
        response.resolve success: true
        @resources.promise.then (resources) ->
          for res in resources
            if res._id is resource._id
              for key, value of resource
                res[key] = value
      .error (data) ->
        data.success = false
        response.resolve data
        console.log 'server error has occurred', data

    response.promise

  delete: (resource) ->
    response = @$q.defer()
    @$http.delete("/api/v1/resources/#{resource._id}")
    .success (data) =>
      response.resolve success: true
      @resources.promise.then (resources) -> resources.remove resource
    .error (data) =>
      response.resolve success: false, error: data

    response.promise
