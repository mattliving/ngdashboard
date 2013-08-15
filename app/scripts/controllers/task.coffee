angular.module('jobFoundryApp').controller 'TaskCtrl', ($scope, $http, $routeParams) ->
  $http.get("/api/v1/tasks/#{$routeParams.name}")
  .success (task) ->
    $scope.task = task
  .error -> console.log 'error getting data'
