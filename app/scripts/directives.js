// Generated by CoffeeScript 1.6.3
var __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

angular.module('resourceFoundryDirectives', ['resourceFoundryServices']);

angular.module('resourceFoundryDirectives').directive('tag', function($timeout) {
  return {
    restrict: 'EA',
    transclude: true,
    scope: {
      key: '@',
      remove: "&"
    },
    template: "<span class=\"tag label label-info\">\n  <span class=\"name\" ng-transclude></span>\n  <a class=\"delete\" href=\"\" ng-show=\"deletable\" ng-click=\"remove({$key: key})\">x</a>\n</span>",
    link: function($s, $e, attrs) {
      if (attrs.deletable != null) {
        $s.deletable = true;
      }
      return $timeout(function() {
        $s.value = $e.find('.name').text();
        return $s.key = attrs.key;
      });
    }
  };
});

angular.module('resourceFoundryDirectives').directive('tagInput', function(keygen) {
  return {
    restrict: 'E',
    scope: {
      suggestions: '=tags',
      tagList: '=ngModel'
    },
    templateUrl: "views/tag-input.html",
    link: function($s, $e, attrs) {
      var highlight;
      if ($s.tagList == null) {
        $s.tagList = [];
      }
      _.map($s.tagList, function(el) {
        if (angular.isString(el)) {
          return {
            key: keygen(el),
            value: el
          };
        }
      });
      $s.hIndex = 0;
      highlight = function(inc) {
        var newHIndex, suggestions;
        newHIndex = $s.hIndex + inc;
        suggestions = $e.find('.suggestion').length;
        if (newHIndex < suggestions && newHIndex >= 0) {
          return $s.hIndex = newHIndex;
        } else if (newHIndex < 0) {
          return $s.hIndex = 0;
        } else {
          return $s.hIndex = suggestions - 1;
        }
      };
      $s.$watch('tagInput', function() {
        return highlight(0);
      });
      $e.find('input').on('keydown', function(e) {
        var _ref;
        if ((_ref = e.keyCode) === 40 || _ref === 38) {
          e.preventDefault();
        }
        return $s.$apply(function() {
          switch (e.keyCode) {
            case 40:
              return highlight(1);
            case 38:
              return highlight(-1);
            case 13:
              if ($e.find('.highlight').length > 0) {
                return $s.tagInput = $e.find('.highlight').text();
              } else {
                return $s.tagInput = $e.find('.suggestion').get($s.hIndex).innerText;
              }
          }
        });
      });
      $s.addTag = function() {
        var key, tag;
        tag = $s.tagInput;
        key = keygen(tag);
        if (key && __indexOf.call(_.pluck($s.tagList, "key"), key) < 0) {
          if (__indexOf.call(_.pluck($s.suggestions, "key"), key) >= 0) {
            $s.tagList.push(_.where($s.suggestions, {
              key: key
            })[0]);
          } else {
            $s.tagList.push({
              key: key,
              value: tag
            });
          }
          $s.tagInput = "";
          return $s.hIndex = 0;
        }
      };
      return $s.removeTag = function(name) {
        return $s.tagList = _.filter($s.tagList, function(el) {
          return el.key !== name;
        });
      };
    }
  };
});
