'use strict';

describe('LoginCtrl', function() {

    var scope;

    beforeEach(module('luckyDashApp'));

    // mock the controller and include $rootScope and $controller
    beforeEach(inject(function($rootScope, $controller) {
        scope = $rootScope.$new();
        // declare the controller and inject the empty scope
        $controller('LoginCtrl', {$scope: scope});
    }));

    it('should have account email', function() {

    });
});