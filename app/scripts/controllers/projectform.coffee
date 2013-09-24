angular.module('jobFoundryApp').controller 'ProjectFormCtrl', ($scope, $location, $routeParams, dashify, Project, Task) ->

  do reset = ->
    $scope.projects = Project.query()
    $scope.tasks = Task.query()

    $scope.input = new Project()
    $scope.input.modules = []

    $scope.createName = yes

  if $routeParams.name?
    $scope.createName = no
    $scope.editing    = yes
    $scope.input      = Project.get name: $routeParams.name

  $scope.$watch 'input.title', ->
    if $scope.input.title is "" then $scope.createName = yes
    if $scope.createName
      $scope.input.name = $scope.input.title

  $scope.$watch 'input.name', ->
    $scope.input.name = dashify $scope.input.name

  $scope.createModule = (title) ->
    newModule =
      title: title
      name: dashify title
      tasks: []
    $scope.input.modules.push newModule
    $scope.selectedModule = newModule

  $scope.addTask = (task) ->
    if $scope.selectedModule?
      unless task in $scope.selectedModule.tasks
        $scope.selectedModule.tasks.push task
    else
      alert 'you must select/create a module first'

  $scope.removeTask = (task) ->
    $scope.selectedModule.tasks.remove task

  $scope.isTaskAdded = (task) ->
    if $scope.selectedModule?
      task not in $scope.selectedModule.tasks
    else true

  $scope.addProject = ->
    for module in $scope.input.modules
      module.tasks = _.pluck module.tasks, '_id'
    if $scope.editing
      $scope.input.$update (-> alert 'updated project'), (-> alert 'there was an error updating the project, see console for details')
    else
      $scope.input.$save((-> console.log('saved project')), (-> alert 'there was an error saving the project, see console for details'))
      reset()
