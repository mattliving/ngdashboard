angular.module('jobFoundryApp').controller 'TaskFormCtrl', ($scope, $http, $location, $routeParams, Task, Resource, levels, costs, paths, map) ->
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
    $scope.tasks = Task.query()
    task = new Task()
    task.outcomes = []
    task.resources = []

    resource = new Resource()

    $scope.resourceInput = resource
    $scope.input = task
    $scope.inputResources = []

  if $routeParams.name?
    $scope.editing = yes
    $scope.input = Task.get name: $routeParams.name, ->
      $scope.inputResources = $scope.input.resources

  $scope.addOutcome = (outcome) ->
    $scope.input.outcomes.push outcome

  $scope.addTask = ->
    $scope.input.resources = _.pluck $scope.inputResources, '_id'
    if $scope.editing
      $scope.input.$update (-> alert 'updated task'), (-> alert 'there was an error updating the task, see console for details')
    else
      $scope.input.$save((-> console.log('saved task')), (-> alert 'there was an error saving the task, see console for details'))
      reset()

  $scope.deleteTask = ->
    if confirm 'are you sure you want to delete this task?'
      $scope.input.$delete (->
        alert 'deleted resource'
        $location.path '/add/task'
        ), (-> alert 'there was an error deleting the resource, see console')

  $scope.addResource = (resource) ->
    if resource not in $scope.inputResources
      $scope.inputResources.push resource

  $scope.createResource = ->
    $scope.resourceInput.$save -> console.log 'saved resource'
    $scope.inputResources.push $scope.resourceInput
    $scope.resourceInput = new Resource()
    # $scope.resourceInput.$save()
