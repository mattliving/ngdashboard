angular.module('resourceFoundryApp').controller 'ListCtrl', ($scope, $routeParams, map, Resources) ->

  $scope.valueFor = map

  $scope.resources = Resources.get()
  $scope.path = $routeParams.path
