"use strict"

angular.module("jobFoundryApp").controller "LandingCtrl", ($http, $scope) ->

  $scope.subscribe = false

  $http.get('/api/v1/content/options').success (options) ->
    $scope.options = options
