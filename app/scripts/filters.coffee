angular.module 'jobFoundryFilters', []

angular.module('jobFoundryFilters').filter 'join', ->
	(array) -> if array? then array.join ', '
