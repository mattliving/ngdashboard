angular.module('jobFoundryApp').controller 'ProjectFormCtrl', ($scope, $location, $routeParams, dashify, Project, Task) ->

  do reset = ->
    $scope.projects = Project.query()
    $scope.tasks = Task.query()

    $scope.input = new Project()
    $scope.input.modules = []

    $scope.createName = yes

  $scope.$watch 'input.title', ->
    if $scope.input.title is "" then $scope.createName = yes
    if $scope.createName
      $scope.input.name = $scope.input.title

  $scope.$watch 'input.name', ->
    $scope.input.name = dashify $scope.input.name

  # $scope.selectModule = (module) -> $scope.selectedModule = module
    # $scope.selectedModule = _.find $scope.input.modules, {name: moduleName}
    # console.log $scope.selectedModule

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

  $scope.isTaskAdded = (task) ->
    if $scope.selectedModule?
      task not in $scope.selectedModule.tasks
    else true
