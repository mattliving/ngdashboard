angular.module('jobFoundryApp').controller 'TaskCtrl', ($scope, $http, $routeParams, $location, $anchorScroll) ->

  $anchorScroll()

  $http.get("/api/v1/tasks/#{$routeParams.name}")
  .success (task) ->
    $scope.task = task
  .error -> console.log 'error getting data'

  $scope.resourceFilter = {}
  $scope.filterType = (type) ->
    $scope.resourceFilter = (resource) -> type in resource.mediaType

  $scope.hash = (hash) ->
    $location.hash(hash)
    $anchorScroll()
