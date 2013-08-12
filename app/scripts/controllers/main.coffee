'use strict'

angular.module('resourceFoundryApp').controller 'MainCtrl', ($scope, Resources, mediaTypes, topics, levels, costs, paths, map) ->
  $scope.mediaTypes = mediaTypes
  $scope.topics = topics
  $scope.levels = levels
  $scope.costs = costs
  $scope.paths = paths

  $scope.valueFor = map

  $scope.resources = Resources.get()

  $scope.authorCount = 1
  $scope.input =
    authors: [[
      key: "name"
      value :""
    ]]
    cost: "free"

  $scope.testData = ->
    $scope.input =
      path: "webdevelopment"
      level: "all"
      title: "Google"
      link: "http://google.com"
      topic: ["html"]
      mediaType: ["tool"]
      authors: [[
          key: "name"
          value: "Sergy Brin"
        ,
          key: "organisation"
          value: "Google"
        ],[
          key: "name"
          value: "Larry Page"
        ,
          key: "organisation"
          value: "Google"
      ]]
      cost: "free"
      description: "BEST SITE EVER USE IT FOR EVERYTHING"

  $scope.addAuthorAttr = (author, attr) ->
    if attr and attr not in _.pluck author, "key"
      author.push
        key: attr
        value: ""

  $scope.removeAuthorAttr = (author, attr) ->
    for val, i in author
      if val.key is attr
        author.splice i, 1
        return

  $scope.$watch 'authorCount', (newVal) ->
    if newVal <= 0 then return

    diff = newVal - $scope.input.authors.length
    if diff > 0
      while diff-- > 0
        $scope.input.authors.push [
          key: "name"
          value: ""
        ]
    else if diff < 0
      if diff is -1 then $scope.input.authors.pop()
      else
        $scope.input.authors.splice ($scope.input.authors.length - 1 + diff), diff*-1

  $scope.addResource = ->
    input = angular.copy $scope.input
    if not (input.level and input.path and input.cost)
      alert "you must have a level, path and cost"
      return

    input.authors = input.authors.map (attrs) ->
      author = {}
      _.each attrs, (attr) -> author[attr.key] = attr.value
      return author

    Resources.add(_.defaults input,
      topic: []
      mediaType: []
      description: ""
      authors: [
        name: ""
      ]
      cost: "free"
    ).then (res) ->
      if res.success
        $scope.input =
          authors: []
      else
        console.log res
        alert 'there was an error with your request, see console for details'



