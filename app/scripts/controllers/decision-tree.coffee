"use strict"

angular.module("jobFoundryApp").controller "DecisionTreeCtrl", ($scope) ->

  $s = $scope

  $s.tree =
    a: 
      question: "What would you like to build?"
      options: [
          name: "Web Site or Application"
          child: "b"
        ,
          name: "Mobile Application"
          child: "c"
        ,
          name: "Social Media Presence"
      ]
      parent: ""
    b:
      question: "What kind of web site is it?"
      options: [
          name: "Web Application"
          examples: ["Facebook", "Twitter", "Gmail"]
          child: "d"
        ,
          name: "Content-based Site"
          examples: ["Blog", "Photography Portfolio"]
        ,
          name: "Online Store"
          examples: ["Amazon", "Boutique Retailers"]
      ]
      parent: "a"
    c:
      question: "Which platform are you targetting?"
      options: [
          name: "iOS"
        ,
          name: "Android"
        ,
          name: "Mobile Web"
      ]
      parent: "a"
    d: 
      question: "Choose an option."
      options: [
          name: "Node.js"
          description: "Node.js allows the development of fast, scalable web applications written entirely in JavaScript."
          language: "JavaScript"
        ,
          name: "Ruby on Rails"
          description: "Ruby on Rails is one of the most popular web frameworks, favouring convention over configuration to make development faster and easier."
          language: "Ruby"
        ,
          name: "Django"
          description: "The favoured web framework for Pythonists."
          language: "Python"
      ]
      parent: "b"

  $s.nodes       = []
  $s.decisions   = []
  curNode        = $s.tree.a
  $s.curQuestion = curNode.question
  $s.options     = curNode.options
  $s.nodes.push curNode

  # stepping through the options in the decision tree
  $s.step = (chosen) ->
    # keep a list of all of the chosen options
    $s.decisions.push chosen.name

    # hide the choices that weren't chosen
    for option in curNode.options
      if option.name isnt chosen.name
        option.hidden = true

    if chosen.child?
      curNode        = $s.tree[chosen.child]
      $s.curQuestion = curNode.question
      $s.options     = curNode.options
      $s.nodes.push curNode
    else 
      console.log $s.decisions

    console.log $s.nodes

  # $s.showDescription = (option) ->
  #   console.log "show Desc"
  #   console.log option.hasOwnProperty 'description'

  $s.showExamples = (option) ->
    console.log "show Examples"
    console.log(option.hasOwnProperty 'examples' and mouseover)

    