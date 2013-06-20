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
      <a class="delete" href="" ng-show="deletable" ng-click="remove({tagName: tag})">x</a>
      <input type="hidden" value="{{tag}}">
    </span>
    """
  link: (scope, elem, attrs) ->
    if attrs.deletable? then scope.deletable = true

angular.module('resourceFoundryDirectives').directive 'keyup', ->
  restrict: 'A'
  link: (scope, elem, attrs) ->
    elem.bind 'keyup', (e) ->
      scope.$apply attrs.keyup

angular.module('resourceFoundryDirectives').directive 'tagInput', ->
  restrict: 'E'
  scope:
    tagSuggest: '=tags'
  template: """
    <form class="tag-input" ng-submit="addTag()">
      <input keyup="suggest()" type="text" class="tag" ng-model="tagInput">
      <div class="suggest">
        <div class="suggestion" ng-repeat="tag in suggestions">{{tag}}</div>
      </div>
      <button class="btn btn-primary" type="submit">Add Tag</button>
      <div tag="tag" ng-repeat="tag in tagList" remove="removeTag(tagName)" deletable></div>
    </form>
    """
  link: (scope, elem, attrs) ->
    scope.tagList = []
    scope.suggestions = []

    scope.addTag = ->
      scope.tagList.push(scope.tagInput)
      scope.tagInput = ""

    scope.removeTag = (name) ->
      scope.tagList = _.without scope.tags, name

    scope.suggest = ->
      if scope.tagInput.length > 0
        scope.suggestions = _.take _.filter(scope.tagSuggest, (tag) -> _contains tag, scope.tagInput), 5
      else
        scope.suggestions = []
