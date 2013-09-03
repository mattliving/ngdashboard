angular.module('jobFoundryApp').controller 'ProjectOverviewCtrl', ($scope, $routeParams, Project) ->

  $scope.active = {}
  $scope.active.hidden = false

  $scope.project = Project.get
    id: $routeParams.id, (project) ->
      $scope.active.task = project.tasks.shift()
      $scope.tasks       = project.tasks

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
