"use strict"

angular.module("jobFoundryApp").controller "DecisionFlowCtrl", ["$scope", "$log", "Tree", ($s, $log, Tree) ->

  $s.tree = Tree

  $s.decisions = []
  $s.current   = 'a'

  $s.step = (chosen) ->
    if chosen.child?
      $s.current = chosen.child
    chosen.parent = $s.tree[$s.current].parent
    $s.decisions.push chosen

  $s.navigate = (decision, index) ->
    $s.decisions.splice index, $s.decisions.length
    $s.current = decision.parent
]
