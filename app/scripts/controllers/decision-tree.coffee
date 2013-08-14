"use strict"

angular.module("jobFoundryApp").controller "DecisionTreeCtrl", ($scope) ->

  $s = $scope

  $s.tree =
    a: 
      question: "What would you like to build?"
      options: [
        {
          name: "Web Application"
          child: "b"
        },
        {
          name: "Mobile Application"
          child: "c"
        },
        {
          name: "Social Media Presence"
          child: ""
        }
      ]
      parent: ""
    b:
      question: "What kind of content will you be hosting?"
      options: [
        {
          name: "Static Content"
          child: ""
        },
        {
          name: "Dynamic Content"
          child: ""
        }
      ]
      parent: "a"
    c:
      question: "Which platform are you targetting?"
      options: [
        {
          name: "iOS"
          child: ""
        },
        {
          name: "Android"
          child: ""
        },
        {
          name: "Mobile Web"
          child: ""
        }
      ]
      parent: "a"

  $s.decisions   = []
  curNode        = $s.tree.a
  $s.curQuestion = curNode.question
  $s.options     = curNode.options
  $s.decisions.push curNode

  $s.step = (next) ->
    curNode        = $s.tree[next]
    $s.curQuestion = curNode.question
    $s.options     = curNode.options
    $s.decisions.push curNode

    