angular.module("jobFoundryApp").controller "DecisionFlowCtrl", ["$scope", ($s) ->

  $s.tree =
    a:
      question: "What would you like to build?"
      options: [
          name: "Website"
          child: "b"
        ,
          name: "Mobile Application"
          child: "c"
        ,
          name: "Social Media Presence"
      ]
      current: false
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
      current: false
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
      current: false
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
      current: false
      parent: "b"

  $s.decisions = []
  $s.current   = "a"

  $s.step = (chosen) ->
    $s.decisions.push chosen
    if chosen.child?
      $s.current = chosen.child
]
