'use strict';

describe('DashboardCtrl', function() {

    var scope;

    beforeEach(module('luckyDashApp'));

    // mock the controller and include $rootScope and $controller
    beforeEach(inject(function($rootScope, $controller) {
        scope = $rootScope.$new();
        // declare the controller and inject the empty scope
        $controller('DashboardCtrl', {$scope: scope});
    }));

    it('should return properly formatted graph data', function() {
        var graphTestData = [{
            date: "2013-11-01",
            revenue: 34.99,
            time: "11:33:07",
            x: 1,
            y: 34.99
        },
        {
            date: "2013-11-01",
            revenue: 29.98,
            time: "13:18:32",
            x: 1,
            y: 29.98
        },
        {
            date: "2013-11-01",
            revenue: 683.22,
            time: "15:15:38",
            x: 1,
            y: 683.22
        },
        {
            date: "2013-11-01",
            revenue: 34.99,
            time: "15:45:15",
            x: 1,
            y: 34.99
        },
        {
            date: "2013-11-01",
            revenue: 34.99,
            time: "17:17:08",
            x: 1,
            y: 34.99
        }];

        var graphResultData = [];
        graphResultData.push({
            x: 1,
            y: 818.1700000000001
        });
        expect(scope.formatGraphData('monthly_revenue', graphTestData)).toEqual(graphResultData);
    });

    it('should have account email', function() {
        expect(scope.account.email).not.toBe(null);
    });
});