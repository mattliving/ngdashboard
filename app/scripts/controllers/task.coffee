angular.module('jobFoundryApp').controller 'TaskCtrl', ($scope, $http, $routeParams, Task, types, map, mediaTypes) ->

  types('resource').success (resourceTypes) ->
    $scope.resourceMap = (key) ->
      for resource in resourceTypes
        if resource.key is key
          return resource.value

  $scope.valueOf = map

  $scope.task = Task.get name: $routeParams.name

  $scope.filter = {}

  urlParser = document.createElement 'a'
  $scope.domain = (link) ->
    urlParser.href = link
    host = urlParser.hostname
    if host[0..2] is 'www'
      host[4..]
    else
      host
