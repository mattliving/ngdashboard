angular.module('jobFoundryApp').controller 'TaskFormCtrl', ($scope, Task, Resource) ->
  $scope.tasks = Task.query()
  $scope.resources = Resource.query()

  do reset = ->
    $scope.input =
      outcomes: []
      resources: []
    $scope.inputResources = []

  $scope.addOutcome = (outcome) ->
    $scope.input.outcomes.push outcome

  $scope.addTask = ->
    # this will need to turn the list of resources into a list with just the ids
    $scope.input.resources = _.pluck $scope.inputResources, '_id'
    console.log $scope.input
    reset()

  $scope.addResource = (resource) ->
    $scope.inputResources.push resource
