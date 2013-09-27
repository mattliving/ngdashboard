'use strict'

# I know you're not meant to do this, but not having an array removal function
# is incredibly annoying. Nice one JavaScript.
Array::remove = (e) -> @splice i, 1 if (i = @indexOf e) isnt -1

angular.module('jobFoundryApp', ['jobFoundryDirectives', 'jobFoundryServices', 'jobFoundryFilters', 'resourceData', 'ui.bootstrap', 'ngResource', 'ngRoute', 'ngAnimate'])
  .config ($routeProvider, $locationProvider, $httpProvider) ->
    $routeProvider
      .when '/',
        templateUrl: '/views/landing.html'
        controller: 'LandingCtrl'
      .when '/404',
        templateUrl: '/views/error.html'
        # controller: 'ErrorCtrl'
      .when '/add/resource',
        templateUrl: '/views/resource-form.html'
        controller: 'ResourceCtrl'
      .when '/edit/resource/:id',
        templateUrl: '/views/resource-form.html'
        controller: 'ResourceCtrl'
      .when '/list/resource/:path',
        templateUrl: '/views/list.html'
        controller: 'ResourceCtrl'
      .when '/add/task',
        templateUrl: '/views/task-form.html'
        controller: 'TaskFormCtrl'
      .when '/task/:tname/edit',
        templateUrl: '/views/task-form.html'
        controller: 'TaskFormCtrl'
      .when '/add/project',
        templateUrl: '/views/project-form.html'
        controller: 'ProjectFormCtrl'
      .when '/projects/:pname/edit',
        templateUrl: '/views/project-form.html'
        controller: 'ProjectFormCtrl'
      .when '/projects/:pname',
        templateUrl: '/views/project-dashboard.html'
        controller: 'ProjectDashboardCtrl'
        reloadOnSearch: false
      .when '/projects/:pname/:tname',
        templateUrl: '/views/task.html'
        controller: 'TaskCtrl'
      .when '/task/:tname',
        templateUrl: '/views/task.html'
        controller: 'TaskCtrl'
        reloadOnSearch: false
      .when '/learn-more',
        templateUrl: "/views/learn-more.html"
        controller: 'LandingCtrl'
        reloadOnSearch: false
      .otherwise
        redirectTo: '/404'
    $locationProvider.html5Mode true
