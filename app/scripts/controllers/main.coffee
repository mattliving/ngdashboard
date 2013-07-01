'use strict'

angular.module('resourceFoundryApp').controller 'MainCtrl', ($scope, $http) ->

  $http(method: 'GET', url: '/data.json')
    .success (data, status, config) ->
      $scope.authors = _.uniq _.flatten(_.pluck data, "authors"), JSON.stringify
      window.authors = $scope.authors
      $scope.mediaTypes = _.map _.uniq(_.flatten _.pluck(data, "mediaType")), (el) -> key: el, value: el
      $scope.topics = _.map(_.uniq(_.flatten _.pluck(data, "topic")), (el) -> key: el, value: el)
    .error -> console.log 'error :('

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

  $scope.costs = [
    key: "free"
    value: "Free"
  ,
    key: "paid"
    value: "Paid"
  ,
    key: "freemium"
    value: "Freemium"
  ]

  # temporary bootstrapped data
  $scope.resources = [
    path:"webdevelopment"
    title:"Google"
    link:"http://www.google.com"
    level:"all"
    description: "Use this for EVERYTHING"
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
      key: "reference"
      value: "Reference"
    ,
      key: "tutorial"
      value: "Tutorial"
    ,
      key: "tool"
      value: "Tool"
    ]
    author:
      name: "Google"
    cost: "free"
  ,
    path:"webdevelopment"
    title:"Angular UI Bootstrap"
    link:"http://angular-ui.github.io/bootstrap/"
    level:"beginner"
    topics: [
      key:"angular"
      value:"angular"
    ,
      key:"javascript"
      value:"javascript"
    ]
    mediaTypes:[
      key: "tool"
      value:"tool"
    ]
    cost:"free"
    author:
      name:"Angular UI Team"
      twitter:"@angularui"
      github:"angular-ui"
  ]

  $scope.addResource = ->
    $scope.resources.push angular.copy $scope.input
    $scope.input = {}
