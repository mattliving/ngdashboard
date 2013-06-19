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

  $scope.authors = [
    name: "Addy Osmani"
  ,
    name: "Rebecca Black"
  ]

  $scope.authorSelectOptions =
    multiple: false
    data: $scope.authors
    createSearchChoice: (term, data) ->
      console.log term, data
      if term not in data
        return id: term, text: term
      else
        return null

  # temporary bootstrapped data
  $scope.resources = [
    path:"webdevelopment"
    title:"Google"
    link:"http://www.apple.com"
    level:"all"
    topics:[
      "html",
      "css",
      "javascript"
    ]
    mediaTypes:[
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
