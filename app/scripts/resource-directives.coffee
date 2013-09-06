angular.module('jobFoundryDirectives').directive 'authorInput', ->
  restrict: 'E'
  scope:
    authors: '='
  templateUrl: '/views/author-input.html'
  link: (scope, elem, attrs) ->

    if scope.authors?.length > 0 and angular.isArray scope.authors
      console.log 'transforming', scope.authors
      # this transforms the existsing author data into the right format.
      # from: [{name: "Alex", org: "jobfoundry"}]
      # to: [[{key: "name", value: "Alex"},{key: "org", value: "jobfoundry"}]]
      # currently does not work with two way binding, but this could be changed
      scope.authorCount = scope.authors.length
      scope.authorsArray = []
      for author in scope.authors
        newAuthor = []
        for key, val of author
          # console.log attr
          newAuthor.push
            key: key
            value: val
        scope.authorsArray.push newAuthor
    else
      # scope.authors will be set automatically by the watch function
      scope.authorCount = 1
      scope.authorsArray = [[
        key: "name"
        value: ""
      ]]

    scope.$watch 'authorsArray', (newVal, oldVal) ->
      scope.updatedAuthors = true
      scope.authors = []
      for author in scope.authorsArray
        newAuthor = {}
        for attr in author
          newAuthor[attr.key] = attr.value
        scope.authors.push newAuthor
    , true

    scope.$watch 'authors', ->
      scope.authors ?= [
        name: ""
      ]
      unless scope.updatedAuthors
        scope.authorCount = scope.authors?.length or 0
        scope.authorsArray = []
        for author in scope.authors
          newAuthor = []
          for key, val of author
            # console.log attr
            newAuthor.push
              key: key
              value: val
          scope.authorsArray.push newAuthor
      else
        scope.updatedAuthors = false
    , true
    # updates the authors array as the user adds new authors
    scope.$watch 'authorCount', (newVal) ->
      if newVal <= 0 then return

      diff = newVal - scope.authorsArray.length
      if diff > 0
        while diff-- > 0
          scope.authorsArray.push [
            key: "name"
            value: ""
          ]
      else if diff < 0
        if diff is -1 then scope.authorsArray.pop()
        else
          scope.authorsArray.splice (scope.authorsArray.length - 1 + diff), diff*-1

    scope.addAuthorAttr = (author, attr) ->
      if attr and attr not in _.pluck author, "key"
        author.push
          key: attr
          value: ""

    scope.removeAuthorAttr = (author, attr) ->
      for val, i in author
        if val.key is attr
          author.splice i, 1
          return

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
