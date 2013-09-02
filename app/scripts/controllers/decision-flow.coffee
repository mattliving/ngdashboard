"use strict"

angular.module("jobFoundryApp").controller "DecisionFlowCtrl", ($window, $scope, $location, Tree) ->

  $scope.tree = Tree

  $scope.decisions = []
  $scope.current   = 'a'

  $scope.step = (chosen) ->
    if chosen.child?
      $scope.current = chosen.child
    else
      $location.path '/projects/' + chosen.project
    chosen.parent = $scope.tree[$scope.current].parent
    $scope.decisions.push chosen

  $scope.navigate = (decision, index) ->
    $scope.decisions.splice index, $scope.decisions.length-index
    $scope.current = decision.parent
