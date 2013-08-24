angular.module('jobFoundryApp').controller 'TaskCtrl', ($scope, $http, $routeParams, map, mediaTypes) ->

  $scope.mediaTypes = mediaTypes
  $scope.valueOf = map

  $http.get("/api/v1/tasks/#{$routeParams.name}")
  .success (task) ->
    $scope.task = task
  .error -> console.log 'error getting data'

  $scope.resourceFilter = {}
  $scope.filterType = (type) ->
    $scope.resourceFilter = (resource) -> type in resource.mediaType
