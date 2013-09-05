angular.module('jobFoundryApp').controller 'ResourceCtrl', ($scope, $routeParams, $location, $http, Resource, levels, costs, paths, map) ->

  # get the media and resource types
  $http.get("/api/v1/types").success (types) ->
    types = _.groupBy types, 'type'
    for type, val of types
      typeMap = {}
      for pair in val
        typeMap[pair.key] = pair.value
      $scope[type+"Types"] = typeMap

  $scope.levels     = levels
  $scope.costs      = costs
  $scope.paths      = paths

  # used in the list view
  $scope.path = $routeParams.path

  $scope.deleteResource = (resource) ->
    if confirm("Are you sure you want to delete this resource?")
      Resource.delete(id: resource._id)
      $scope.resources.remove resource

  $scope.valueFor = map

  $scope.resources = Resource.query()

  window.scope = $scope

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
    Resource.get id: $routeParams.id, (resource) ->
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
        console.log 'about to call push'
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

    input.authors = input.authors.map (attrs) ->
      author = {}
      _.each attrs, (attr) -> author[attr.key] = attr.value
      return author

    if $scope.editing
      input._id = $routeParams.id
      updatedResource = Resource.update id: input._id, input
    else
      input = _.defaults input,
        topic: []
        mediaType: []
        description: ""
        authors: [
          name: ""
        ]
        cost: "free"
      updatedResource = Resource.save input

    updatedResource.success (res) ->
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



