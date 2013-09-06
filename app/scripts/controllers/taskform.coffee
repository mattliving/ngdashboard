angular.module('jobFoundryApp').controller 'TaskFormCtrl', ($scope, $http, Task, Resource, levels, costs, paths, map) ->
  $scope.tasks = Task.query()
  $scope.resources = Resource.query()

  window.scope = $scope

  # get the media and resource types
  $http.get("/api/v1/types").success (types) ->
    types = _.groupBy types, 'type'
    for type, val of types
      typeMap = {}
      for pair in val
        typeMap[pair.key] = pair.value
      $scope[type+"Types"] = typeMap

  $scope.levels = levels
  $scope.costs  = costs
  $scope.paths  = paths

  do reset = ->
    task = new Task()
    task.outcomes = []
    task.resources = []

    resource = new Resource()

    $scope.resourceInput = resource
    $scope.input = task
    $scope.inputResources = []

  $scope.addOutcome = (outcome) ->
    $scope.input.outcomes.push outcome

  $scope.addTask = ->
    # this will need to turn the list of resources into a list with just the ids
    $scope.input.resources = _.pluck $scope.inputResources, '_id'
    console.log $scope.input
    $scope.input.$save -> console.log 'saved task'
    reset()

  $scope.addResource = (resource) ->
    if resource not in $scope.inputResources
      $scope.inputResources.push resource

  $scope.createResource = ->
    $scope.resourceInput.$save -> console.log 'saved resource'
    $scope.inputResources.push $scope.resourceInput
    $scope.resourceInput = new Resource()
    # $scope.resourceInput.$save()
