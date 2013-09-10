angular.module('jobFoundryApp').controller 'ProjectFormCtrl', ($scope, $location, $routeParams, Project, Task) ->
  $scope.projects = Project.query()

  $scope.selectModule = (module) ->

  $scope.createModule = (title) ->

  $scope.addTask = (task) ->
