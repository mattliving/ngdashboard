angular.module('jobFoundryApp').controller 'TaskCtrl', ($scope, $http, $routeParams, types, map, mediaTypes) ->

  types('resource').success (resourceTypes) ->
    $scope.resourceMap = (key) ->
      for resource in resourceTypes
        if resource.key is key
          return resource.value

  $scope.valueOf = map

  $http.get("/api/v1/tasks/#{$routeParams.name}")
  .success (task) ->
    console.log task
    $scope.task = task
  .error -> console.log 'error getting data'

  $scope.filter = {}

  urlParser = document.createElement 'a'
  $scope.domain = (link) ->
    urlParser.href = link
    host = urlParser.hostname
    if host[0..2] is 'www'
      host[4..]
    else
      host
