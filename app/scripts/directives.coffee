'use strict'

angular.module 'jobFoundryDirectives', ['jobFoundryServices']

angular.module('jobFoundryDirectives').directive 'decision', ->
  restrict: 'E'
  scope:
    question: '@'
    options: '='
    nextFunc: "&next"
  templateUrl: "/views/decision.html"
  link: (scope, elem, attrs) ->

angular.module('jobFoundryDirectives').directive 'sticky', ($window) ->
  (scope, elem, attrs) ->
    elemPos = elem.offset().top
    $($window).scroll ->
      if elemPos < $window.scrollY
        unless elem.hasClass('sticky-fixed')
          elem.addClass('sticky-fixed')
      else
        elem.removeClass('sticky-fixed')

angular.module('jobFoundryDirectives').directive 'scrollSpy', ($window) ->
  restrict: 'A'
  controller: ($scope) ->
    $scope.spies = []
    @addSpy = (spyObj) -> $scope.spies.push spyObj
  link: (scope, elem, attrs) ->
    spyElems = []
    scope.$watch 'spies', (spies) ->
      for spy in spies
        unless spyElems[spy.id]?
          spyElems[spy.id] = elem.find('#'+spy.id)

    $($window).scroll ->
      highlightSpy = null
      for spy in scope.spies
        spy.out()
        if (pos = spyElems[spy.id].offset().top) - $window.scrollY <= 0
          spy.pos = pos
          highlightSpy ?= spy
          if highlightSpy.pos < spy.pos
            highlightSpy = spy

      highlightSpy?.in()

angular.module('jobFoundryDirectives').directive 'spy', ($location) ->
  restrict: "A"
  require: "^scrollSpy"
  link: (scope, elem, attrs, scrollSpy) ->
    scrollSpy.addSpy
      id: attrs.spy
      in: ->
        if $location.hash() isnt attrs.spy
          scope.$apply ->
            $location.hash attrs.spy, false
        elem.addClass 'current',
      out: -> elem.removeClass 'current'

angular.module('jobFoundryDirectives').directive 'enterKey', ->
  (scope, elem, attrs) ->
    elem.bind 'keydown', (e) ->
      if e.keyCode is 13
        e.preventDefault()
        scope.$apply attrs.enterKey

angular.module('jobFoundryDirectives').directive 'tag', ($timeout) ->
  restrict: 'EA'
  transclude: true
  scope:
    key: '@'
    remove: "&"
  template: """
    <span class="tag label label-info">
      <span class="name" ng-transclude></span>
      <a class="delete" href="" ng-show="deletable" ng-click="remove({$key: key})">x</a>
    </span>
    """
  link: (scope, elem, attrs) ->
    if attrs.deletable? then scope.deletable = true
    $timeout ->
      scope.value = elem.find('.name').text()
      scope.key   = attrs.key

angular.module('jobFoundryDirectives').directive 'tagInput', (keygen) ->
  restrict: 'E'
  scope:
    tags: '='
    tagList: '=ngModel'
    placeholder: '@'
  templateUrl: "/views/tag-input.html"
  link: ($s, $e, attrs) ->
    $s.canCreate = attrs.create?
    $s.tagList ?= []

    # highlight the tag that will be chosen when the enter key is pressed
    $s.hIndex = 0
    highlight = (inc) ->
      newHIndex = $s.hIndex + inc
      suggestions = $e.find('.suggestion').length
      if newHIndex < suggestions and newHIndex >= 0
        $s.hIndex = newHIndex
      else if newHIndex < 0
        $s.hIndex = 0
      else
        $s.hIndex = suggestions - 1

    $e.find('input').on 'keydown', (e) ->
      if e.keyCode in [40, 38, 13]
        e.preventDefault()
      else
       $s.downKey = false

      $s.$apply ->
        switch e.keyCode
          when 40
            highlight 1
            $s.downKey = true
          when 38
            highlight -1
          when 13
            highlight 0
            # keydown is called before the submission, so changing the input
            # means the form will be submitted with the new value of tagInput
            if $e.find('.highlight').length > 0
              $s.tagInput = $e.find('.highlight').text()
            else
              $s.tagInput = $e.find('.suggestion').get($s.hIndex).innerText
            $s.addTag()
          else
            highlight 0

        if $s.tagList?
          $s.sCount = 0
          $s.suggestions = _.filter $s.tags, (val, key) ->
            if $s.sCount < 5
              if (key.indexOf($s.tagInput) >= 0 or val.indexOf($s.tagInput) >= 0) and key not in $s.tagList
                $s.sCount++
                true
            else false
        else
          $s.sCount = 5
          $s.suggestions = _.take $s.tags, 5

    $s.addTag = ->
      tag = $s.tagInput
      key = keygen tag

      if key and key not in $s.tagList
        if $s.canCreate or key of $s.tags
          $s.tagList.push key
          $s.tagInput = ""
          $s.hIndex = 0
          if key not of $s.tags
            $s.tags[key] = tag

    $s.removeTag = (name) ->
      $s.tagList.remove name
