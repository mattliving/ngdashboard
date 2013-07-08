'use strict'

# static key-value maps for data types
angular.module("resourceFoundryData", [])

angular.module("resourceFoundryData").value "mediaTypes",
  article: "Article"
  reference: "Reference"
  tutorial: "Tutorial"
  tool: "Tool"
  talk: "Talk"
  video: "Video"
  blog: "Blog"
  book: "Book"

# this data changes, so this especially will need to update from the server
angular.module("resourceFoundryData").value "topics",
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

angular.module("resourceFoundryData").value "levels",
  beginner:"Beginner"
  intermediate:"Intermediate"
  advanced:"Advanced"
  all:"All"

angular.module("resourceFoundryData").value "costs",
  free: "Free"
  paid: "Paid"
  freemium: "Freemium"

angular.module("resourceFoundryData").value "paths",
  webdevelopment: "Web Development"
  marketing: "Marketing"

angular.module("resourceFoundryData").factory "map", (mediaTypes, topics, levels, costs, paths) ->
  _.memoize (mapName, key) ->
    map = switch mapName
            when "mediaType" then mediaTypes
            when "topic" then topics
            when "level" then levels
            when "cost" then costs
            when "path" then paths

    if map[key]? then map[key] else key
  , (arg1, arg2) -> arg1+arg2
