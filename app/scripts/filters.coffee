angular.module 'jobFoundryFilters', []

angular.module('jobFoundryFilters').filter 'join', ->
	(array) ->
		array.join ', '		

angular.module('jobFoundryFilters').filter 'eg', ->
	(string) ->
		'(e.g. ' + string + ')'
