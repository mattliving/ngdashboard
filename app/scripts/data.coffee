'use strict'

# static key-value maps for data types
angular.module("jobFoundryData", [])

angular.module("jobFoundryData").value "mediaTypes",
  article: "Article"
  reference: "Reference"
  tutorial: "Tutorial"
  tool: "Tool"
  talk: "Talk"
  video: "Video"
  blog: "Blog"
  book: "Book"

# this data changes, so this especially will need to update from the server
angular.module("jobFoundryData").value "topics",
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

angular.module("jobFoundryData").value "levels",
  beginner:"Beginner"
  intermediate:"Intermediate"
  advanced:"Advanced"
  all:"All"

angular.module("jobFoundryData").value "costs",
  free: "Free"
  paid: "Paid"
  freemium: "Freemium"

angular.module("jobFoundryData").value "paths",
  webdevelopment: "Web Development"
  marketing: "Marketing"

angular.module("jobFoundryData").factory "map", (mediaTypes, topics, levels, costs, paths) ->
  _.memoize (mapName, key) ->
    map = switch mapName
            when "mediaType" then mediaTypes
            when "topic" then topics
            when "level" then levels
            when "cost" then costs
            when "path" then paths

    if map[key]? then map[key] else key
  , (arg1, arg2) -> arg1+arg2
