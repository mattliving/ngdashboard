angular.module 'resourceFoundryDirectives', ['resourceFoundryServices']

angular.module('resourceFoundryDirectives').directive 'tag', ($timeout) ->
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
  link: ($s, $e, attrs) ->
    if attrs.deletable? then $s.deletable = true
    $timeout ->
      $s.value = $e.find('.name').text()
      $s.key = attrs.key

angular.module('resourceFoundryDirectives').directive 'tagInput', (keygen) ->
  restrict: 'E'
  scope:
    suggestions: '=tags'
    tagList: '=ngModel'
    placeholder: '@'
  templateUrl: "views/tag-input.html"
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

    $s.$watch 'tagInput', -> highlight 0

    $e.find('input').on 'keydown', (e) ->
      if e.keyCode in [40, 38, 13]
        e.preventDefault()

      $s.$apply ->
        switch e.keyCode
          when 40
            highlight 1
          when 38
            highlight -1
          when 13
            # keydown is called before the submission, so changing the input
            # means the form will be submitted with the new value of tagInput
            if $e.find('.highlight').length > 0
              $s.tagInput = $e.find('.highlight').text()
            else
              $s.tagInput = $e.find('.suggestion').get($s.hIndex).innerText
            $s.addTag()

    $s.addTag = ->
      tag = $s.tagInput
      key = keygen tag

      if key and key not in _.pluck $s.tagList, "key"
        if key in _.pluck $s.suggestions, "key"
          $s.tagList.push _.where($s.suggestions, key: key)[0]
          $s.tagInput = ""
          $s.hIndex = 0
        else if $s.canCreate
          $s.tagList.push key: key, value: tag
          $s.tagInput = ""
          $s.hIndex = 0


    $s.removeTag = (name) ->
      $s.tagList = _.filter $s.tagList, (el) -> el.key isnt name

