angular.module('jobFoundryApp').controller 'ProjectFormCtrl', ($scope, $location, $routeParams, Project, Task) ->

  do reset = ->
    $scope.projects = Project.query()
    $scope.tasks = Task.query()

    $scope.input = new Project()
    $scope.input.tasks = []
    $scope.inputTasks = {}

    $scope.createName = yes

  $scope.$watch 'input.title', ->
    if $scope.input.title is "" then $scope.createName = yes
    if $scope.createName
      $scope.input.name = $scope.input.title

  $scope.$watch 'input.name', ->
    $scope.input.name = $scope.input.name?.replace(/-/g, " ").split(" ").map((word) -> word.replace(/\W/g, '').toLowerCase()).join("-")

  $scope.selectModule = (module) ->
    $scope.selectedModule = $scope.inputTasks[module]
    $scope.selectedModuleTitle = module

  $scope.createModule = (title) ->
    $scope.inputTasks[title] = []
    $scope.selectModule title

  $scope.addTask = (task) ->
    if $scope.selectedModule?
      unless task in $scope.selectedModule
        $scope.selectedModule.push task
    else
      alert 'you must select/create a module first'
