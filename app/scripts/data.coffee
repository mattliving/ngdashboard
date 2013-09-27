# static key-value maps for data types
angular.module("resourceData", [])

angular.module("resourceData").factory "types", ($http) ->
  types = {}
  (type) ->types[types] ?= $http.get("/api/v1/types/#{type}")

angular.module("resourceData").value "mediaTypes",
  article: "Article"
  reference: "Reference"
  tutorial: "Tutorial"
  tool: "Tool"
  talk: "Talk"
  video: "Video"
  blog: "Blog"
  book: "Book"

# this data changes, so this especially will need to update from the server
angular.module("resourceData").value "topics",
  html: "HTML"
  css: "CSS"
  javascript: "JavaScript"
  frontend: "Front End"
  jquery: "jQuery"
  backbone: "Backbone"
  tooling: "Tooling"
  haml: "HAML"
  less: "LESS"
  sass: "SASS"
  angular: "AngularJS"

angular.module("resourceData").value "levels",
  beginner:"Beginner"
  intermediate:"Intermediate"
  advanced:"Advanced"
  all:"All"

angular.module("resourceData").value "costs",
  free: "Free"
  paid: "Paid"
  freemium: "Freemium"

angular.module("resourceData").value "paths",
  webdevelopment: "Web Development"
  marketing: "Marketing"

angular.module("resourceData").factory "map", (mediaTypes, topics, levels, costs, paths) ->
  _.memoize (mapName, key) ->
    map = switch mapName
            when "mediaType" then mediaTypes
            when "topic" then topics
            when "level" then levels
            when "cost" then costs
            when "path" then paths

    if map[key]? then map[key] else key
  , (arg1, arg2) -> arg1+arg2
