angular.module('jobFoundryApp').controller 'TaskCtrl', ($scope, $http, $routeParams, map, mediaTypes) ->

  $scope.mediaTypes = mediaTypes
  $scope.valueOf = map

  $http.get("/api/v1/tasks/#{$routeParams.name}")
  .success (task) ->
    $scope.task = task
  .error -> console.log 'error getting data'

  $scope.filter = {}
  $scope.filterFunc = (resource) ->
    if _.isEmpty $scope.filter
      return true
    else
      for type, filter of $scope.filter
        if filter and type not in resource.mediaType
          return false
      return true

  urlParser = document.createElement 'a'
  $scope.domain = (link) ->
    urlParser.href = link
    host = urlParser.hostname
    if host[0..2] is 'www'
      host[4..]
    else
      host
