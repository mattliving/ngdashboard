'use strict'

angular.module('resourceFoundryApp').controller 'MainCtrl', ($scope, Resources, mediaTypes, topics, levels, costs, paths, map) ->
  $scope.mediaTypes = mediaTypes
  $scope.topics = topics
  $scope.levels = levels
  $scope.costs = costs
  $scope.paths = paths

  $scope.valueFor = map

  Resources.get().then (resources) ->
    $scope.resources = resources
    $scope.authors = _.uniq _.flatten(_.pluck resources, "authors"), JSON.stringify

  # temporary bootstrapped data
  # $scope.resources = [
  #   id: 0
  #   path:"webdevelopment"
  #   title:"Google"
  #   link:"http://www.google.com"
  #   level:"all"
  #   description: "Use this for EVERYTHING"
  #   topic: [
  #     "html"
  #     "css"
  #     "javascript"
  #   ]
  #   mediaType: [
  #     "reference"
  #     "tutorial"
  #     "tool"
  #   ]
  #   authors:
  #     name: "Google"
  #   cost: "free"
  # ,
  #   id: 1
  #   path:"webdevelopment"
  #   title:"Angular UI Bootstrap"
  #   link:"http://angular-ui.github.io/bootstrap/"
  #   level:"beginner"
  #   topic: [
  #     "angular"
  #     "javascript"
  #   ]
  #   mediaType:["tool"]
  #   cost:"free"
  #   authors:
  #     name:"Angular UI Team"
  #     twitter:"@angularui"
  #     github:"angular-ui"
  # ]

  $scope.addResource = ->
    Resources.add _.defaults angular.copy($scope.input),
      topic: []
      mediaType: []
      description: ""
      authors: [
        name: ""
      ]
      cost: "free"
    $scope.input = {}
