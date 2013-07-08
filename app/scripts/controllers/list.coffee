'use strict'

angular.module('resourceFoundryApp').controller 'ListCtrl', ($scope, $routeParams, map, levels, Resources) ->
  $scope.valueFor = map
  $scope.levels = levels
  $scope.resources = Resources.get()
  $scope.path = $routeParams.path
