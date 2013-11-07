'use strict';

describe('DashboardCtrl', function() {

    var scope;

    beforeEach(module('luckyDashApp'));

    // mock the controller and include $rootScope and $controller
    beforeEach(inject(function($rootScope, $controller, $httpBackend) {
        scope = $rootScope.$new();
        // declare the controller and inject the empty scope
        $controller('DashboardCtrl', {$scope: scope});
    }));

    it('should return properly formatted graph data', function() {
        var revenueGraphData = [{
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

        var revenueGraphResults = [{
            x: 1,
            y: 818.1700000000001
        }];

        var adCostGraphData = [{
            ad_cost: 324.85000000000014,
            date: "2013-11-01",
            time: "00:00:00",
            x: 1,
            y: 324.85000000000014
        },
        {
            ad_cost: 12.62,
            date: "2013-11-02",
            time: "00:00:00",
            x: 2,
            y: 12.62
        },
        {
            ad_cost: 22.46,
            date: "2013-11-03",
            time: "00:00:00",
            x: 3,
            y: 22.46
        },
        {
            ad_cost: 389.93000000000006,
            date: "2013-11-04",
            time: "00:00:00",
            x: 4,
            y: 389.93000000000006
        },
        {
            ad_cost: 27.21,
            date: "2013-11-05",
            time: "00:00:00",
            x: 5,
            y: 27.21
        }];

        var adCostGraphResults = [{
            x: 1,
            y: 324.85000000000014
        },
        {
            x: 2,
            y: 12.62
        },
        {
            x: 3,
            y: 22.46
        },
        {
            x: 4,
            y: 389.93000000000006
        },
        {
            x: 5,
            y: 27.21
        }];

        expect(scope.formatGraphData('monthly_revenue', revenueGraphData)).toEqual(revenueGraphResults);
        expect(scope.formatGraphData('monthly_ad_cost', adCostGraphData)).toEqual(adCostGraphResults);
    });

    it('should not have empty metrics or graphs', function() {
        expect(scope.metrics).not.toBeNull();
        expect(scope.graphs).not.toBeNull();
    })

    it('should have account email', function() {
        expect(scope.account.email).not.toBeNull();
    });
});