'use strict'

angular.module('resourceFoundryApp').controller 'ListCtrl', ($scope, $routeParams, map, levels, Resources) ->
  $scope.valueFor = map
  $scope.levels = levels
  $scope.resources = Resources.get()
  $scope.path = $routeParams.path

  $scope.deleteResource = (resource) ->
    if confirm("Are you sure you want to delete this resource?") then Resources.delete(resource)
