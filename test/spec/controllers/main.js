'use strict';

describe('Controller: MainCtrl', function () {

  // load the controller's module
  beforeEach(module('resourceFoundryApp'));

  var MainCtrl, scope, injection;

  // Initialize the controller and a mock scope
  beforeEach(inject(function ($controller, $rootScope) {
    scope = $rootScope.$new();
    injection = {
      $scope: scope,
      $http: function() {
        return {
          success: function(){return this;},
          error: function(){return this}
        }
      }
    };

    spyOn(injection, '$http').andCallThrough();

    MainCtrl = $controller('MainCtrl', injection);
  }));

  it('should attach the paths and levels to the scope', function () {
    expect(angular.isArray(scope.paths)).toBe(true);
    expect(angular.isArray(scope.levels)).toBe(true);
  });

  it('should have the resources array with the correct fields', function () {
    expect(angular.isArray(scope.resources)).toBe(true);

    var r = scope.resources[0];
    expect(r.path).toBeDefined();
    expect(r.title).toBeDefined();
    expect(r.link).toBeDefined();
    expect(r.level).toBeDefined();
    expect(angular.isArray(r.topics)).toBe(true);
    // and so on. This is beyond pointless.
  });

  it('should add a resource to the end of the array', function () {
    var input = {
      path: "webdevelopment",
      title: "A title"
    }
    scope.resources = [];
    scope.input = input;
    scope.addResource();
    expect(scope.resources).toContain(input);
  });

  it('should try to get data from the server', function() {
    expect(injection.$http).toHaveBeenCalled();
  })
});
