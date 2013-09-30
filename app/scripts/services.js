
angular.module('luckyDashAppServices', []);

angular.module('luckyDashAppServices').factory('dashify', function() {
  return function(string) {
    return string != null ? string.replace(/-/g, " ").split(" ").map(function(word) {
      return word.replace(/\W/g, '').toLowerCase();
    }).join("-") : void 0;
  };
});

angular.module('luckyDashAppServices').factory('Project', function($resource) {
  return $resource('api/v1/projects/:name', {
    name: '@name'
  }, {
    update: {
      method: "PUT"
    }
  });
}).factory('Task', function($resource) {
  return $resource('api/v1/tasks/:name/:cmd', {
    name: '@name'
  }, {
    update: {
      method: "PUT"
    }
  });
}).factory('Resource', function($resource) {
  return $resource('api/v1/resources/:id', {
    id: '@id'
  }, {
    update: {
      method: "PUT"
    }
  });
});
