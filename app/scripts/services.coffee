angular.module 'jobFoundryServices', []

# simple key creation from values for now, may be more complex later
angular.module('jobFoundryServices').factory 'keygen', -> (string) -> string.toLowerCase().replace(" ", "")

angular.module('jobFoundryServices').factory 'Tree', ->
  Tree =
    a:
      content:
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
      parent: ""
      type: "choice"
    b:
      content:
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
      type: "choice"
    c:
      content:
        question: "Which platform are you targetting?"
        options: [
            name: "iOS"
          ,
            name: "Android"
          ,
            name: "Mobile Web"
        ]
      parent: "a"
      type: "choice"
    d:
      content:
        question: "Choose a framework."
        options: [
            name: "Node.js"
            description: "Node.js allows the development of fast, scalable web applications written entirely in JavaScript."
            language: "JavaScript"
            project: "nodejs-web-app"
          ,
            name: "Ruby on Rails"
            description: "Ruby on Rails is one of the most popular web frameworks, favouring convention over configuration to make development faster and easier."
            language: "Ruby"
            project: "ruby-on-rails-web-app"
          ,
            name: "Django"
            description: "The favoured web framework for Pythonists."
            language: "Python"
            project: "django-web-app"
        ]
      parent: "b"
      type: "choice"
    e:
      content:
        question: "What skills do you have?"
        options: [
            name: "HTML"
          ,
            name: "CSS"
          ,
            name: "JavaScript"
        ]
      parent: "d"
      type: "evaluation"

# api access
angular.module('jobFoundryServices')
  .factory 'Project', ($resource) ->
    $resource 'api/v1/projects/:name', name: '@name'
  .factory 'Task', ($resource) ->
    $resource 'api/v1/tasks/:name/:cmd', {name: '@name'}, update: {method: "PUT"}
  .factory 'Resource', ($resource) ->
    $resource 'api/v1/resources/:id', {id: '@id'}, update: {method: "PUT"}
