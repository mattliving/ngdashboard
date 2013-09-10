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
      .when '/getting-started',
        templateUrl: 'views/getting-started.html'
        controller: 'DecisionFlowCtrl'
        reloadOnSearch: false
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
      .when '/task/:name/edit',
        templateUrl: '/views/task-form.html'
        controller: 'TaskFormCtrl'
      .when '/add/project',
        templateUrl: '/view/project-form.html'
        controller: 'ProjectFormCtrl'
      .when '/projects/:id',
        templateUrl: '/views/project-overview.html'
        controller: 'ProjectOverviewCtrl'
        reloadOnSearch: false
      .when '/task/:name',
        templateUrl: '/views/task.html'
        controller: 'TaskCtrl'
        reloadOnSearch: false
      .when '/learn-more',
        templateUrl: "/views/learn-more.html"
        controller: 'LandingCtrl'
        reloadOnSearch: false
      .otherwise
        redirectTo: '/'
    $locationProvider.html5Mode true

