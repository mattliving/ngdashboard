'use strict'

angular.module('resourceFoundryServices', [])

# simple key creation from values for now, may be more complex later
angular.module('resourceFoundryServices').factory 'keygen', -> (string) -> string.toLowerCase().replace(" ", "")

angular.module('resourceFoundryServices').service 'Resource',
  class Resource

    contructor: (@$http, @$q) ->
      @maps = @$q.defer()
      @resources = @$q.defer()
      @fetchAll()

    fetchAll: ->
      @$http(method: 'GET', url: '/data.json')
        .success (data, status, config) ->
          @resources.resolve data
          unless maps?
            @maps.resolve
              authors: _.uniq _.flatten(_.pluck data, "authors"), JSON.stringify
              mediaTypes: _.map _.uniq (_.flatten _.pluck(data, "mediaType")), (el) -> key: el, value: el
              topics: _.map _.uniq(_.flatten _.pluck(data, "topic")), (el) -> key: el, value: el
        .error ->
          console.log 'data error has occurred'
          @resources.reject 'error fetching data'

    getMaps: -> @maps.promise
    getResources: -> @resources.promise

    addResource: (resource) ->
      @resources.promise.then (resources) -> resources.push resource
      # this will have a way to send the data to the server in future.

