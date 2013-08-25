"use strict"

angular.module("jobFoundryApp").controller "DecisionFlowCtrl", ["$scope", "Tree", "$log", ($s, Tree, $log) ->

  $s.tree = Tree

  # $s.$log = $log

  $s.decisions = []
  # $s.crumb = {}
  # $s.crumb = 0
  $s.current   = 'a'

  $s.step = (chosen) ->
    $s.decisions.push chosen
    if chosen.child?
      $s.current = chosen.child

  $s.toggle = (index) ->
    console.log index

  # $s.$watchCollection 'decisions', (old, new) ->
  #   console.log new
]
