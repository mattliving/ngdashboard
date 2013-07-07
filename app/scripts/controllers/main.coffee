'use strict'

angular.module('resourceFoundryApp').controller 'MainCtrl', ($scope, $http, Resource, mediaTypes, topics, levels, costs, paths, map) ->

  $http(method: 'GET', url: '/data.json')
    .success (data, status, config) ->
      $scope.authors = _.uniq _.flatten(_.pluck data, "authors"), JSON.stringify
      window.scope = $scope
      # data format does not currently match
      # $scope.resources = data
    .error -> console.log 'error :('

  $scope.mediaTypes = mediaTypes
  $scope.topics = topics
  $scope.levels = levels
  $scope.costs = costs
  $scope.paths = paths

  $scope.valueFor = map

  # temporary bootstrapped data
  $scope.resources = [
    id: 0
    path:"webdevelopment"
    title:"Google"
    link:"http://www.google.com"
    level:"all"
    description: "Use this for EVERYTHING"
    topics: [
      "html"
      "css"
      "javascript"
    ]
    mediaTypes: [
      "reference"
      "tutorial"
      "tool"
    ]
    author:
      name: "Google"
    cost: "free"
  ,
    id: 1
    path:"webdevelopment"
    title:"Angular UI Bootstrap"
    link:"http://angular-ui.github.io/bootstrap/"
    level:"beginner"
    topics: [
      "angular"
      "javascript"
    ]
    mediaTypes:["tool"]
    cost:"free"
    author:
      name:"Angular UI Team"
      twitter:"@angularui"
      github:"angular-ui"
  ]

  $scope.addResource = ->
    $scope.resources.push angular.copy $scope.input
    $scope.input = {}
