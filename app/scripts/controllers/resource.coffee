'use strict'

angular.module('jobFoundryApp').controller 'ResourceCtrl', ($scope, $routeParams, $location, Resources, mediaTypes, topics, levels, costs, paths, map) ->
  $scope.mediaTypes = mediaTypes
  $scope.topics     = topics
  $scope.levels     = levels
  $scope.costs      = costs
  $scope.paths      = paths

  # used in the list view
  $scope.path = $routeParams.path

  $scope.deleteResource = (resource) ->
    if confirm("Are you sure you want to delete this resource?") then Resources.delete(resource)

  $scope.valueFor = map

  $scope.resources = Resources.get()

  $scope.authorCount = 1
  $scope.input =
    authors: [[
      key: "name"
      value :""
    ]]
    cost: "free"

  $scope.editing = false

  # get and modify the data to be used in the form correctly
  if $routeParams.id?
    $scope.editing = true
    Resources.get($routeParams.id).then (resource) ->
      authorsData = []
      for author in resource.authors
        authorData = []
        for key, value of author
          authorData.push key: key, value: value
        authorsData.push authorData
      resource.authors = authorsData
      $scope.input = resource

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

    if $scope.editing
      input._id = $routeParams.id
      fetch = Resources.edit input
    else
      fetch = Resources.add _.defaults input,
        topic: []
        mediaType: []
        description: ""
        authors: [
          name: ""
        ]
        cost: "free"

    fetch.then (res) ->
      if res.success
        $scope.input =
          authors: []
          mediaType: []
          topics: []

        if $scope.editing
          $location.path "/add"
      else
        console.log res
        alert 'there was an error with your request, see console for details'



