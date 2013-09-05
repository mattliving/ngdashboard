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

angular.module('jobFoundryServices')
  .factory 'Project', ($resource) ->
    $resource 'api/v1/projects/:id', id: '@id'
  .factory 'Task', ($resource) ->
    $resource 'api/v1/tasks/:name', name: '@name'
  .factory 'Resource', ($resource) ->
    $resource 'api/v1/resources/:id', {id: '@id'}, update: {method: "PUT"}

angular.module('jobFoundryServices').service 'Resources', ->
  class Resources
  # ngmin can't detect the dependencies in CoffeeScript's class syntax
  Resources.$inject = ['$http', '$q', '$rootScope']
  constructor: (@$http, @$q, @$rootScope) ->
    @fetch()

  fetch: ->
    @resources = @$q.defer()
    @$http.get('/api/v1/resources')
      .success (data, status) =>
        @resources.resolve data
      .error =>
        console.log 'data error has occurred'
        @resources.reject 'error fetching data'

  get: (id) ->
    if id?
      resource = @$q.defer()
      @$http.get("/api/v1/resources/#{id}")
        .success (data) ->
          resource.resolve data
        .error ->
          console.log 'error getting specific id'
          resource.reject 'error getting specific id'

      resource.promise
    else
      @resources.promise

  add: (resource) ->
    response = @$q.defer()
    @$http.post('/api/v1/resources', resource)
      .success (data) =>
        response.resolve success: true
        @resources.promise.then (resources) ->
          resource._id = data[0]._id
          resources.unshift resource
      .error (data) ->
        data.success = false
        response.resolve data
        console.log 'server error has occurred', data

    response.promise

  edit: (resource) ->
    response = @$q.defer()
    @$http.put("/api/v1/resources/#{resource._id}", resource)
      .success (data) =>
        response.resolve success: true
        @resources.promise.then (resources) ->
          for res in resources
            if res._id is resource._id
              for key, value of resource
                res[key] = value
      .error (data) ->
        data.success = false
        response.resolve data
        console.log 'server error has occurred', data

    response.promise

  delete: (resource) ->
    response = @$q.defer()
    @$http.delete("/api/v1/resources/#{resource._id}")
    .success (data) =>
      response.resolve success: true
      @resources.promise.then (resources) -> resources.remove resource
    .error (data) =>
      response.resolve success: false, error: data

    response.promise
