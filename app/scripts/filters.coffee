angular.module 'jobFoundryFilters', []

angular.module('jobFoundryFilters').filter 'join', ->
	(array) ->
		array.join ', '
