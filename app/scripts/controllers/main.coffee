"use strict"

angular.module('resourceFoundryApp').controller 'MainCtrl', ($scope) ->
  $scope.resources = []

  $scope.addResource = ->
    console.log $scope
    $scope.resources.push
      link: $scope.input.url
      level: $scope.input.level

    $scope.input = {}


