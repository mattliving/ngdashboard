angular.module('jobFoundryApp').controller 'TaskCtrl', ($scope, $http, $routeParams, Task, types, map, mediaTypes) ->

  $scope.valueOf = map

  types('resource').success (resourceTypes) ->
    $scope.resourceMap = (key) ->
      for resource in resourceTypes
        if resource.key is key
          return resource.value

  $scope.task = Task.get name: $routeParams.name, cmd: 'group'
  mainResources = {}
  $scope.mainResource = (type) -> if mainResources[type]? then mainResources[type] else mainResources[type] = $scope.task?.resources?[type][0]
  $scope.setMainResource = (type, resource) ->
    console.log type, resource
    mainResources[type] = resource
  $scope.filter = {}
