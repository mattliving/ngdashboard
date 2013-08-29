'use strict'

# I know you're not meant to do this, but not having an array removal function
# is incredibly annoying. Nice one JavaScript.
Array::remove = (e) -> @splice i, 1 if (i = @indexOf e) isnt -1

angular.module('jobFoundryApp', ['jobFoundryDirectives', 'jobFoundryServices', 'jobFoundryFilters', 'resourceData', 'ui.bootstrap', 'ngResource', 'ngRoute', 'ngAnimate'])
  .config ($routeProvider, $locationProvider) ->
    $routeProvider
      .when '/',
        templateUrl: '/views/landing.html'
        controller: 'LandingCtrl'
      .when '/getting-started',
        templateUrl: 'views/getting-started.html'
        controller: 'DecisionFlowCtrl'
        reloadOnSearch: false
      .when '/add',
        templateUrl: '/views/resource-form.html'
        controller: 'ResourceCtrl'
      .when '/edit/:id',
        templateUrl: '/views/resource-form.html'
        controller: 'ResourceCtrl'
      .when '/list/:path',
        templateUrl: '/views/list.html'
        controller: 'ResourceCtrl'
      .when '/projects/overview',
        templateUrl: '/views/project-overview.html'
        controller: 'ProjectOverviewCtrl'
        reloadOnSearch: false
      .when '/task/:name',
        templateUrl: '/views/task.html'
        controller: 'TaskCtrl'
        reloadOnSearch: false
      .otherwise
        redirectTo: '/'
    $locationProvider.html5Mode true

