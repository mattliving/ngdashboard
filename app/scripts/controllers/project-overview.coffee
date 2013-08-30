angular.module('jobFoundryApp').controller 'ProjectOverviewCtrl', ($scope, $http, $routeParams, Project, Task) ->

  $scope.project = Project.get
    id: $routeParams.id, (project) ->
      $scope.first = project.tasks.shift()
      $scope.tasks = project.tasks

  # $http.get("/api/v1/projects/")
  # .success (tasks) ->
  #   $scope.first = tasks.shift()
  #   $scope.tasks = tasks
  # .error -> console.log 'error getting data'
