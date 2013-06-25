"use strict"

angular.module('resourceFoundryApp', ['ui.select2', 'resourceFoundryDirectives', 'resourceFoundryServices', 'ui.bootstrap'])
  .config ($routeProvider, $locationProvider) ->
    $routeProvider
      .when '/',
        templateUrl: 'views/main.html'
        controller: 'MainCtrl'
      .otherwise
        redirectTo: '/'

    $locationProvider.html5Mode true
