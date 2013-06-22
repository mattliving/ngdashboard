angular.module 'resourceFoundryDirectives', []

angular.module('resourceFoundryDirectives').directive 'tag', ->
  restrict: 'A'
  replace: true
  scope:
    remove: "&"
    tag: "="
  template: """
    <span class="tag label label-info">
      <span class="name">{{tag}}</span>
      <a class="delete" href="" ng-show="deletable" ng-click="remove({name: tag})">x</a>
    </span>
    """
  link: (scope, elem, attrs) ->
    if attrs.deletable? then scope.deletable = true

# helper filter doesn't need to be in a separate location
angular.module('resourceFoundryDirectives').filter 'without', -> (input, item) -> _.without input, item

angular.module('resourceFoundryDirectives').directive 'tagInput', ->
  restrict: 'E'
  scope:
    tagSuggest: '=tags'
  templateUrl: "views/tag-input.html"
  link: (scope, elem, attrs) ->

    scope.tagList = []

    # highlight the tag that will be chosen when the enter key is pressed
    highlightNum = 0
    do highlight = ->
      suggestions = elem.find('.suggestion')
      if suggestions.length > 0
        if highlightNum >= suggestions.length
          highlightNum = suggestions.length - 1
        else if highlightNum < 0
          highlightNum = 0

        suggestions.removeClass 'highlight'
        suggestions.get(highlightNum).className += ' highlight'

    scope.$watch 'tagInput', highlight

    elem.find('input').on 'keydown', (e) ->
      if e.keyCode in [40, 38]
        e.preventDefault()

      switch e.keyCode
        when 40
          highlightNum++
          highlight()
        when 38
          highlightNum--
          highlight()
        when 13
          # keydown is called before the submission, so changing the input
          # means the form will be submitted with the new value of tagInput
          scope.tagInput = elem.find('.suggestion').get(highlightNum).innerText

    scope.addTag = ->
      if scope.tagInput and scope.tagInput not in scope.tagList
        scope.tagList.push scope.tagInput
        scope.tagInput = ""

    scope.removeTag = (name) ->
      scope.tagList = _.without scope.tagList, name

