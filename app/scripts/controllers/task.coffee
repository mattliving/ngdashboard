angular.module('jobFoundryApp').controller 'TaskCtrl', ($scope, $http, $routeParams, $location, Task, CurrentProject, types, map, mediaTypes) ->

  $scope.valueOf = map

  types('resource').success (resourceTypes) ->
    $scope.resourceTypes = resourceTypes
    $scope.resourceMap = (key) ->
      for resource in resourceTypes
        if resource.key is key
          return resource.value + "s"
      return "Unsorted Resources"


  Task.get name: $routeParams.tname, cmd: 'group',
    (task) ->
      $scope.task = task

      # initialise mainResources to hold the first resource of each type
      $scope.mainResources = {}
      for {key} in $scope.resourceTypes
        $scope.mainResources[key] = $scope.task.resources[key]?[0]

      if $routeParams.pname? and CurrentProject.currentModule?
        CurrentProject.get $routeParams.pname,
          success: (project) ->
            $scope.projectName = project.name
            console.log project.modules

            # finds the name of the next and previous tasks if they exist, for routing purposes
            tasks = _.flatten project.modules, "tasks"
            taskIndex = _.findIndex tasks, _id: $scope.task._id

            $scope.prevTaskName = tasks[taskIndex-1]?.name
            $scope.nextTaskName = tasks[taskIndex+1]?.name
    , (response) ->
      console.log response
      $location.path('/404')

  $scope.filter = {}
