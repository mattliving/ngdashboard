"use strict"

angular.module("resourceFoundryApp").controller "LandingCtrl", ($scope) ->

	$scope.subscribe = false
	$scope.options = [
  	"Web Application",
  	"Mobile Application",
  	"Social Media Presence"
  ]
