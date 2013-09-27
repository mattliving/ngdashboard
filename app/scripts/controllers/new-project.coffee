angular.module('jobFoundryApp').controller 'NewProjectCtrl', ($scope, $routeParams, $log, Project) ->

  $scope.active        = {}
  $scope.active.hidden = false
  $scope.selected      = 'decisions'

  $scope.project = {}
  $scope.project.title = 'New Project'
