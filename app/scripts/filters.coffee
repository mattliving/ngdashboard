angular.module 'jobFoundryFilters', []

angular.module('jobFoundryFilters').filter 'join', ->
	(array) ->
		array.join ', '		

angular.module('jobFoundryFilters').filter 'isEmpty', ->
	(array) ->
		if array.length is 0 then true else false

# angular.module('jobFoundryFilters').filter 'isCurrent', ->
# 	(item) ->
# 		(_.first item).current
