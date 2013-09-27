angular.module 'jobFoundryDirectives', ['jobFoundryServices']

angular.module('jobFoundryDirectives').directive 'inviteForm', ->
  restrict: 'E'
  scope:
    show: '='
  templateUrl: "/views/invite-form.html"
  link: (scope, elem, attrs) ->
    scope.show ?= true

angular.module('jobFoundryDirectives').directive 'decisionFlow', ($location, Tree) ->
  restrict: 'E'
  templateUrl: '/views/decision-flow.html'
  link: (scope, elem, attrs) ->
    scope.tree = Tree

    scope.decisions = []
    scope.current   = 'a'

    scope.step = (chosen) ->
      if chosen.child?
        scope.current = chosen.child
      else
        $location.path '/projects/' + chosen.project
      chosen.parent = scope.tree[scope.current].parent
      scope.decisions.push chosen

    scope.navigate = (decision, index) ->
      scope.decisions.splice index, scope.decisions.length-index
      scope.current = decision.parent

angular.module('jobFoundryDirectives').directive 'decision', ->
  restrict: 'E'
  scope:
    type: '@'
    content: '='
    show: '='
    nextFunc: '&next'
  templateUrl: '/views/decision.html'
  link: (scope, elem, attrs) ->
    # scope.showOnly = (choice) ->
    #   for option in scope.options
    #     option.hidden = option isnt choice

angular.module('jobFoundryDirectives').directive 'choice', ->
  restrict: 'E'
  templateUrl: '/views/choice.html'
  link: (scope, elem, attrs) ->

angular.module('jobFoundryDirectives').directive 'evaluation', ->
  restrict: 'E'
  templateUrl: '/views/evaluation.html'
  link: (scope, elem, attrs) ->

angular.module('jobFoundryDirectives').directive 'multiRepeat', ->
  restrict: 'EA' # challenge EVERYTHING!
  transclude: true
  scope:
    active: '='
    columns: '@'
    collection: '='
    dragging: '&dragging'
  template: '''
    <div class="row multi-items" ng-repeat="(index, items) in set">
      <div class="col-lg-{{12/columns}} multi-item" ng-repeat="item in items">
        <div class="draggable" draggable ng-mousedown="dragging({dragged: item, index: calcIndex($index, $parent)})" ng-transclude></div>
      </div>
    </div>
  '''
  link: (scope, elem, attrs) ->
    scope.$multiParent = scope.$parent
    scope.$watchCollection 'collection', ->
      scope.set = _.groupBy scope.collection, (item) ->
        index = Math.floor ((_.indexOf scope.collection, item) / scope.columns)
    scope.calcIndex = (index, parent) ->
      parseInt(parent.index)*scope.columns+index

angular.module('jobFoundryDirectives').directive 'draggable', ->
  restrict: 'A'
  link: (scope, elem, attrs) ->
    elem.draggable
      revert: true
      zIndex: 9000
      containment: angular.element '.row.task'
      start: (event, ui) ->
        scope.$dragTarget = angular.element(@).find '.well'
        scope.$emit 'startedDragging', scope.$dragTarget.parent().parent()
        scope.$dragTarget.addClass 'translucent'
      stop: (event, ui) ->
        scope.$emit 'stoppedDragging', angular.element(@)
        scope.$dragTarget.removeClass 'translucent'

angular.module('jobFoundryDirectives').directive 'droppable', ->
  restrict: 'A'
  link: (scope, elem, attrs) ->
    elem.droppable
      accept: '.draggable'
      hoverClass: 'drop-hover'
      drop: (event, ui) ->
        scope.tasks[scope.dragged.index] = scope.active.task
        scope.active.task   = scope.dragged
        scope.active.hidden = false
        scope.$apply()

angular.module('jobFoundryDirectives').directive 'progressBar', ->
  restrict: 'E'
  templateUrl: '/views/progress-bar.html'
  scope:
    level: '='
  link: (scope, elem, attrs) ->
    scope.progressBars = []
    scope.progressBars.push
      percent: 0
      rank: "Sparkling"
      bgColour: '#E2B822'
    scope.progressBars.push
      percent: 0
      rank: "Novice"
      bgColour: '#E29822'
    scope.progressBars.push
      percent: 0
      rank: "Fire Dancer"
      bgColour: '#E27822'
    scope.progressBars.push
      percent: 0
      rank: "Expert"
      bgColour: '#E25822'
    scope.progressBars.push
      percent: 0
      rank: "Pyromaster"
      bgColour: '#22ACE2'

    scope.progressUpdate = _.debounce (event) ->
      $target = $(event.currentTarget)
      offset  = $target.offset().left
      width   = $target.width()

      percent = Math.round (event.clientX - offset) / width * 100
      switch true
        when percent > 0 and percent <= 20
          for bar, index in scope.progressBars
            bar.percent = if index <= 0 then 20 else 0
        when percent > 21 and percent <= 40
          for bar, index in scope.progressBars
            bar.percent = if index <= 1 then 20 else 0
        when percent > 41 and percent <= 60
          for bar, index in scope.progressBars
            bar.percent = if index <= 2 then 20 else 0
        when percent > 61 and percent <= 80
          for bar, index in scope.progressBars
            bar.percent = if index <= 3 then 20 else 0
        when percent > 81 and percent <= 100
          for bar, index in scope.progressBars
            bar.percent = if index <= 4 then 20 else 0
    ,
      50
    ,
      leading: true
      trailing: true

angular.module('jobFoundryDirectives').directive 'sticky', ($window) ->
  (scope, elem, attrs) ->
    elemPos = elem.offset().top
    $($window).scroll ->
      if elemPos < $window.scrollY
        unless elem.hasClass("sticky-fixed")
          elem.addClass("sticky-fixed")
      else
        elem.removeClass("sticky-fixed")

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

        # the elem might not have been available when it was originally cached,
        # so we check again to get another element in case this one doesn't exist.
        spyElems[spy.id] =
          if spyElems[spy.id].length is 0
            elem.find('#'+spy.id)
          else
            spyElems[spy.id]

        # the element could still not exist, so we check first
        if spyElems[spy.id].length isnt 0
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
    attrs.spyClass ?= "current"

    elem.click ->
      scope.$apply ->
        $location.hash(attrs.spy)

    scrollSpy.addSpy
      id: attrs.spy
      in: -> elem.addClass attrs.spyClass,
      out: -> elem.removeClass attrs.spyClass
