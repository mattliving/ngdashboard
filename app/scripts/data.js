// Generated by CoffeeScript 1.6.2
(function() {
  'use strict';  angular.module("resourceData", []);

  angular.module("resourceData").value("mediaTypes", {
    article: "Article",
    reference: "Reference",
    tutorial: "Tutorial",
    tool: "Tool",
    talk: "Talk",
    video: "Video",
    blog: "Blog",
    book: "Book"
  });

  angular.module("resourceData").value("topics", {
    html: "HTML",
    css: "CSS",
    javascript: "JavaScript",
    frontend: "Front End",
    jquery: "jQuery",
    backbone: "Backbone",
    tooling: "Tooling",
    haml: "HAML",
    less: "LESS",
    sass: "SASS",
    angular: "AngularJS"
  });

  angular.module("resourceData").value("levels", {
    beginner: "Beginner",
    intermediate: "Intermediate",
    advanced: "Advanced",
    all: "All"
  });

  angular.module("resourceData").value("costs", {
    free: "Free",
    paid: "Paid",
    freemium: "Freemium"
  });

  angular.module("resourceData").value("paths", {
    webdevelopment: "Web Development",
    marketing: "Marketing"
  });

  angular.module("resourceData").factory("map", function(mediaTypes, topics, levels, costs, paths) {
    return _.memoize(function(mapName, key) {
      var map;

      map = (function() {
        switch (mapName) {
          case "mediaType":
            return mediaTypes;
          case "topic":
            return topics;
          case "level":
            return levels;
          case "cost":
            return costs;
          case "path":
            return paths;
        }
      })();
      if (map[key] != null) {
        return map[key];
      } else {
        return key;
      }
    }, function(arg1, arg2) {
      return arg1 + arg2;
    });
  });

}).call(this);
