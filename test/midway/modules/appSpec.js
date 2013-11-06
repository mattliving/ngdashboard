'use strict';

describe("Testing Modules", function() {
  describe("LuckyDashApp Module", function() {

    var module;
    beforeEach(function() {
      module = angular.module('luckyDashApp');
    });

    it("should be registered", function() {
      expect(module).not.toBeNull();
    });

    describe("Dependancies: ", function() {

      var deps;
      var hasModule = function(m) {
        return deps.indexOf(m) >= 0;
      };
      beforeEach(function() {
        deps = module.value('luckyDashApp').requires;
      });

      it("should have luckyDashDirectives as a dependancy", function() {
        expect(hasModule('luckyDashDirectives')).toBe(true);
      });

      it("should have luckyDashServices as a dependancy", function() {
        expect(hasModule('luckyDashServices')).toBe(true);
      });

      it("should have luckyDashFilters as a dependancy", function() {
        expect(hasModule('luckyDashFilters')).toBe(true);
      });

      it("should have ngResource as a dependancy", function() {
        expect(hasModule('ngResource')).toBe(true);
      });

      it("should have ngRoute as a dependancy", function() {
        expect(hasModule('ngRoute')).toBe(true);
      });

      it("should have ngTouch as a dependancy", function() {
        expect(hasModule('ngTouch')).toBe(true);
      });

      it("should have ui.bootstrap as a dependancy", function() {
        expect(hasModule('ui.bootstrap')).toBe(true);
      });
    });
  });
});