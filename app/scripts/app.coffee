'use strict'

angular.module('resourceFoundryApp', ['ui.select2', 'resourceFoundryDirectives', 'resourceFoundryServices', 'resourceFoundryData', 'ui.bootstrap'])
  .config ($routeProvider, $locationProvider) ->
    $routeProvider
      .when '/',
        templateUrl: 'views/main.html'
        controller: 'MainCtrl'
      .when '/list',
        templateUrl: 'views/list.html'
        controller: 'MainCtrl'
      .otherwise
        redirectTo: '/'

    # $locationProvider.html5Mode true
    return
