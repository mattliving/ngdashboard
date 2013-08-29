angular.module('jobFoundryApp').controller 'ProjectOverviewCtrl', ($scope, $http, $routeParams, map, mediaTypes) ->

  $scope.mediaTypes = mediaTypes
  $scope.valueOf = map

  $http.get("/api/v1/tasks")
  .success (tasks) ->
    $scope.tasks = tasks
  .error -> console.log 'error getting data'

  $scope.resourceFilter = {}
  $scope.filterType = (type) ->
    $scope.resourceFilter = (resource) -> type in resource.mediaType
