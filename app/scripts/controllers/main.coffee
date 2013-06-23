'use strict'

angular.module('resourceFoundryApp').controller 'MainCtrl', ($scope, $http, keygen) ->

  $http(method: 'GET', url: '/data.json')
    .success (data, status, config) ->
  #     $scope.authors = _.uniq _.flatten(_.pluck data, "authors"), JSON.stringify
  #     $scope.mediaTypes = _.uniq _.flatten _.pluck(data, "mediaType")
      $scope.topics = _.map(_.uniq(_.flatten _.pluck(data, "topic")), (el) -> key: el, value: el)
  #   .error -> console.log 'error :('

  $scope.paths = [
    key: "webdevelopment"
    value: "Web Development"
  ,
    key: "marketing"
    value: "Marketing"
  ]

  # used as classes for css
  $scope.levels = [
    key: "beginner"
    value: "Beginner"
  ,
    key: "intermediate"
    value: "Intermediate"
  ,
    key: "expert"
    value: "Expert"
  ,
    key: "all"
    value: "All"
  ]

  # to be fetched from server, one resource can have multiple of them
  $scope.topics = [
    key: "html"
    value: "HTML"
  ,
    key: "css"
    value: "CSS"
  ,
    key: "javascript"
    value: "JavaScript"
  ,
    key: "frontend"
    value: "Front End"
  ]

  # multiple can be selected, new types not currently allowed...
  $scope.mediaTypes = ["article", "reference", "tutorial", "tool", "talk", "video"]

  # temporary bootstrapped data
  $scope.resources = [
    path:"webdevelopment"
    title:"Google"
    link:"http://www.apple.com"
    level:"all"
    topics: [
      key: "html"
      value: "HTML"
    ,
      key: "css"
      value: "CSS"
    ,
      key: "javascript"
      value: "JavaScript"
    ]
    mediaTypes: [
      "reference",
      "tutorial",
      "tool"
    ]
  ]

  $scope.addResource = ->
    $scope.resources.push
      path: $scope.input.path
      title: $scope.input.title
      link: $scope.input.url
      level: $scope.input.level
      topics: _.pluck $scope.input.topics, "id"
      mediaTypes: _.pluck $scope.input.types, "id"
      description: $scope.input.description

    $scope.input = {}
