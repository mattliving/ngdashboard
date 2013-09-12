angular.module('jobFoundryApp').controller 'ProjectDashboardCtrl', ($scope, $window, $routeParams, Project) ->

  $scope.active        = {}
  $scope.active.hidden = false
  $scope.selected      = 'tasks'

  $('.container').css 'max-width', $(window).width()

  $scope.project = Project.get
    name: $routeParams.name, (project) ->
      # $scope.active.task = project.tasks.shift()
      if project.modules.length > 0 then $scope.currentModuleIndex = 0

  $scope.$watch 'currentModuleIndex', ->
    $scope.currentModuleTitle = $scope.project.modules[$scope.currentModuleIndex].title
    $scope.tasks              = $scope.project.modules[$scope.currentModuleIndex].tasks

  $scope.setCurrentModuleIndex = (index) ->
    console.log index

  # the current element being dragged
  $scope.dragging = (dragged, index) ->
    dragged.index  = index
    $scope.dragged = dragged

  $scope.$on 'startedDragging', (event) ->
    height = $('#active').height()
    $scope.active.hidden = true
    $scope.$digest()
    $('#drop-zone').height height
    $('#drop-zone h2').css 'line-height', parseInt(height, 10) - 20 + 'px'

  $scope.$on 'stoppedDragging', (event, $dragTarget) ->
    $scope.active.hidden = false
    $scope.$digest()
