angular.module('jobFoundryApp').controller 'ProjectOverviewCtrl', ($scope, $http, $routeParams) ->

  $http.get("/api/v1/tasks")
  .success (tasks) ->
    $scope.first = tasks.shift()
    $scope.tasks = tasks
  .error -> console.log 'error getting data'
