'use strict'

angular.module('resourceFoundryServices', [])

# simple key creation from values for now, may be more complex later
angular.module('resourceFoundryServices').factory 'keygen', -> (string) -> string.toLowerCase().replace(" ", "")

angular.module('resourceFoundryServices').service 'Resources',
  class Resources

    constructor: (@$http, @$q, @$rootScope) ->
      @resources = @$q.defer()
      @fetch()

    fetch: ->
      @$http(method: 'GET', url: '/data.json')
        .success (data, status, config) =>
          @resources.resolve data
        .error =>
          console.log 'data error has occurred'
          @resources.reject 'error fetching data'

    get: ->
      @resources.promise

    add: (resource) ->
      @resources.promise.then (resources) -> resources.push resource
      # this will have a way to send the data to the server in future,
      # and potentially update the promise if need be.

