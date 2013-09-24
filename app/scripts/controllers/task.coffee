angular.module('jobFoundryApp').controller 'TaskCtrl', ($scope, $http, $routeParams, $location, Task, types, map, mediaTypes) ->

  $scope.valueOf = map

  types('resource').success (resourceTypes) ->
    $scope.resourceMap = (key) ->
      for resource in resourceTypes
        if resource.key is key
          return resource.value

  $scope.task = Task.get name: $routeParams.name, cmd: 'group', (->), (response) ->
    console.log response
    $location.path('/404')
  mainResources = {}
  $scope.mainResource = (type) -> mainResources[type] ?= $scope.task?.resources?[type][0]
  $scope.setMainResource = (type, resource) ->
    console.log type, resource
    mainResources[type] = resource
  $scope.filter = {}
