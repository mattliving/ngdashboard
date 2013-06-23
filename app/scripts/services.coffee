angular.module('resourceFoundryServices', [])

# simple key creation from values for now, may be more complex later
angular.module('resourceFoundryServices').factory 'keygen', -> (value) -> value.toLowerCase().replace(" ", "")
