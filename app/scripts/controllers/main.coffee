"use strict"

angular.module('resourceFoundryApp').filter 'capitalise', ->
  (input) -> input.charAt(0).toUpperCase() + input.slice(1)

angular.module('resourceFoundryApp').controller 'MainCtrl', ($scope) ->

  $scope.paths = [
    key: "webdevelopment"
    name: "Web Development"
  ,
    key: "marketing"
    name: "Marketing"
  ]

  # used as classes for css
  $scope.levels = ["beginner", "intermediate", "expert", "all"]

  # to be fetched from server, one resource can have multiple of them
  $scope.topics = ["html", "css", "javascript", "frontend"]

  # multiple can be selected, new types not currently allowed...
  $scope.mediaTypes = ["article", "reference", "tutorial", "tool", "talk", "video"]

  $scope.resources = []

  $scope.addResource = ->
    $scope.resources.push
      title: $scope.input.title
      link: $scope.input.url
      level: $scope.input.level

    $scope.input = {}
