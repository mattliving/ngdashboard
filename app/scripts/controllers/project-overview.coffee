angular.module('jobFoundryApp').controller 'ProjectOverviewCtrl', ($scope, $http, $routeParams, Project, Task) ->

  $scope.project = Project.get
    id: $routeParams.id, (project) ->
      $scope.first = project.tasks.shift()
      $scope.tasks = project.tasks
