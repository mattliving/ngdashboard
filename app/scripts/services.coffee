'use strict'

angular.module 'resourceFoundryServices', []

# simple key creation from values for now, may be more complex later
angular.module('resourceFoundryServices').factory 'keygen', -> (string) -> string.toLowerCase().replace(" ", "")

angular.module('resourceFoundryServices').service 'Resources',
  class Resources

    constructor: (@$http, @$q, @$rootScope) ->
      @resources = @$q.defer()
      @loaded = false
      @fetch()

    fetch: ->
      if @loaded then @resources = @$q.defer()
      @$http.get('/resources')
        .success (data, status, config) =>
          @resources.resolve data
          @loaded = true
        .error =>
          console.log 'data error has occurred'
          @resources.reject 'error fetching data'

    get: -> @resources.promise

    add: (resource) ->
      response = @$q.defer()
      @$http.post('/resources', resource)
        .success (data) =>
          response.resolve success: true
          @resources.promise.then (resources) ->
            resource._id = data._id
            resources.unshift resource
        .error (data) ->
          data.success = false
          response.resolve data
          console.log 'server error has occurred', data

      response.promise

    delete: (resource) ->
      response = @$q.defer()
      @$http(method: "DELETE", url: "/resources/#{resource._id}")
      .success (data) =>
        response.resolve success: true
        @resources.promise.then (resources) -> resources.remove resource
      .error (data) =>
        response.resolve success: false, error: data

      response.promise
