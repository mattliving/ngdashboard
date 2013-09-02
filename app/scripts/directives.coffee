angular.module 'jobFoundryDirectives', ['jobFoundryServices']

angular.module('jobFoundryDirectives').directive 'inviteForm', ->
  restrict: 'E'
  scope:
    show: '='
  templateUrl: "/views/invite-form.html"
  link: (scope, elem, attrs) ->
    scope.show ?= true

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
    <div class="row" ng-repeat="(index, items) in set">
      <div class="col-lg-{{12/columns}}" ng-repeat="item in items">
        <div class="draggable" draggable ng-mousedown="dragging({dragged: item, index: calcIndex($index, $parent)})" ng-transclude></div>
      </div>
    </div>
  '''
  link: (scope, elem, attrs) ->
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
    elem.click ->
      scope.$apply ->
        $location.hash(attrs.spy)

    scrollSpy.addSpy
      id: attrs.spy
      in: -> elem.addClass 'current',
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
      $s.tagList ?= []

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
