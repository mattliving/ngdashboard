angular.module 'jobFoundryServices', []


# simple key creation from values for now, may be more complex later
angular.module('jobFoundryServices').factory 'keygen', -> (string) -> string.toLowerCase().replace(" ", "")

angular.module('jobFoundryServices').factory 'dashify', ->
  (string) -> string?.replace(/-/g, " ").split(" ").map((word) -> word.replace(/\W/g, '').toLowerCase()).join("-")

# api access
angular.module('jobFoundryServices')
  .factory 'Project', ($resource) ->
    $resource 'api/v1/projects/:name', {name: '@name'}, update: {method: "PUT"}
  .factory 'Task', ($resource) ->
    $resource 'api/v1/tasks/:name/:cmd', {name: '@name'}, update: {method: "PUT"}
  .factory 'Resource', ($resource) ->
    $resource 'api/v1/resources/:id', {id: '@id'}, update: {method: "PUT"}

# used to persist project between pages - so task views know the next and previous task
angular.module('jobFoundryServices').service 'CurrentProject', class CurrentProject
  CurrentProject.$inject = ["Project"]
  constructor: (@Project) ->

  currentProject = null
  currentModule: null

  get: (name, {success, err}) ->
    if currentProject? and currentProject.name is name
      success(currentProject)
    else
      @Project.get name: name, success, err

angular.module('jobFoundryServices').factory 'Tree', ->
  Tree =
    a:
      content:
        question: "What type of project are you creating?"
        options: [
            name: "Website or Application"
            child: "b"
          ,
            name: "Mobile Application"
            child: "c"
          ,
            name: "Social Media Marketing"
            project: "create-a-social-media-marketing-strategy"
        ]
      parent: ""
      type: "choice"
    b:
      content:
        question: "What kind of web project is it?"
        options: [
            name: "Web Application"
            examples: ["Facebook", "Twitter", "Gmail"]
            project: "web-application"
          ,
            name: "Content-based Site"
            examples: ["Blog", "Photography Portfolio"]
            child: "g"
          ,
            name: "E-commerce Site"
            examples: ["Any business that buys and sells products or services online."]
            child: "f"
        ]
      parent: "a"
      type: "choice"
    c:
      content:
        question: "Are you an experienced programmer?"
        options: [
            name: "Yes"
            child: "g"
          ,
            name: "No"
            project: "hire-a-freelance-web-developer"
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
    f:
      content:
        question: "Pick an e-commerce platform."
        options: [
          name: "Shopify"
          description: "Incredibly easy to setup and make small customisations, with excellent support."
          site: "http://www.shopify.com/"
        ,
          name: "BigCommerce"
          description: "Quick to setup, easily customisable themes using standard HTML/CSS as well as shipping support for anywhere in the world."
          site: "http://www.bigcommerce.com/go/startyouronlinestore/"
        ,
          name: "Magento"
          description: "The most advanced and complete solution, but which requires developer knowledge and has limited support."
          site: "http://www.magentocommerce.com/product/overview-compare?icid=topnav"
        ]
      parent: "c"
      type: "choice"
    g:
      content:
        question: "Coming soon!"
        options: []
      parent: "c"
      type: "choice"
