angular.module('jobFoundryApp').controller 'TaskCtrl', ($scope, $http, $routeParams, $location, Task, CurrentProject, types, map, mediaTypes) ->

  $scope.valueOf = map

  types('resource').success (resourceTypes) ->
    $scope.resourceMap = (key) ->
      for resource in resourceTypes
        if resource.key is key
          return resource.value + "s"
      return "Unsorted Resources"


  $scope.task = Task.get name: $routeParams.tname, cmd: 'group',
    ->
      if $routeParams.pname
        CurrentProject.get $routeParams.pname,
          success: (project) ->
            $scope.projectName = project.name
            # finds the name of the next and previous tasks if they exist, for routing purposes
            tasks = _.flatten project.modules, "tasks"
            taskIndex = _.findIndex tasks, _id: $scope.task._id
            $scope.prevTaskName = tasks[taskIndex-1]?.name
            $scope.nextTaskName = tasks[taskIndex+1]?.name
    , (response) ->
      console.log response
      $location.path('/404')
  $scope.mainResources = {}
  # if mainResources[type] exists then return it, else set & return the first resource of that type
  $scope.mainResource = (type) -> $scope.mainResources[type] ?= $scope.task?.resources?[type][0]
  $scope.filter = {}
