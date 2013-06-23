"use strict"

angular.module('resourceFoundryApp', ['ui.select2', 'resourceFoundryDirectives', 'resourceFoundryServices'])
  .config ($routeProvider) ->
    $routeProvider
      .when '/',
        templateUrl: 'views/main.html'
        controller: 'MainCtrl'
      .otherwise
        redirectTo: '/'
